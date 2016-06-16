module SoftEvictCache
  class SingleValueCache
    class << self
      def build(soft_evict, hard_evict, &next_value)
        new(soft_evict, hard_evict, next_value)
      end
    end

    class Entry < Struct.new(:value, :soft_evict_at, :hard_evict_at)
      def soft_evicted?
        soft_evict_at < Time.now
      end

      def valid?
        Time.now < hard_evict_at
      end
    end

    def initialize(soft_evict, hard_evict, next_value)
      @soft_evict = soft_evict
      @hard_evict = hard_evict
      @next_value = next_value
      @agent = Concurrent::Agent.new(Entry.new(nil, Time.now - 1, Time.now - 1))
    end

    def update_entry(old_entry, promise = nil)
      return old_entry unless old_entry.soft_evicted?
      value = @next_value.call
      entry = Entry.new(value, Time.now + @soft_evict, Time.now + @hard_evict)
      promise.set(entry) if promise
      entry
    rescue Exception => e
      promise.fail(e) if promise rescue nil
      sleep(0.25) rescue nil
      old_entry
    end

    def value
      current_entry = @agent.value
      if current_entry.valid?
        @agent.send { |old_entry| update_entry(old_entry) } if current_entry.soft_evicted?
        current_entry.value
      else
        promise = Concurrent::Promise.new
        @agent.send { |old_entry| update_entry(old_entry, promise) }
        promise.value!.value
      end
    end
  end
end

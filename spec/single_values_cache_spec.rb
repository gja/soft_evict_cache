require 'spec_helper'

describe SoftEvictCache::SingleValueCache do
  let(:cache) do
    value = 0
    SoftEvictCache::SingleValueCache.build(0.1, 0.2) do
      value += 1
    end
  end

  it 'it caches values immediately' do
    expect(cache.value).to eq(1)
    expect(cache.value).to eq(1)
  end

  it 'hard evicts after three seconds' do
    expect(cache.value).to eq(1)
    sleep(0.2)
    expect(cache.value).to eq(2)
  end

  it "soft evicts after one second" do
    expect(cache.value).to eq(1)
    sleep(0.1)
    expect(cache.value).to eq(1)
    sleep(0.05)
    expect(cache.value).to eq(2)
  end
end

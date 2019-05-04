require 'yaml'
require 'fileutils'

class Cache
  def initialize(location, ttl)
    @location = location
    @ttl = ttl
  end

  def get(key)
    path = store_location(key)

    return false unless File.exist?(path)
    return false if expired?(path)

    File.open(path, 'rb') do |file|
      Marshal.load(file)
    end
  end

  def store(key, value)
    ensure_cache_location
    File.open(store_location(key), 'wb') do |file|
      Marshal.dump(value, file)
    end
  end

  private

  attr_reader :location, :ttl

  def ensure_cache_location
    FileUtils.mkdir_p location
  end

  def expired?(path)
    Time.now - File.ctime(path) > ttl
  end

  def store_location(key)
    filename = sanitize_key(key)
    File.join(location, filename)
  end

  def sanitize_key(key)
    key.gsub(/[^\w]/, '')
  end
end

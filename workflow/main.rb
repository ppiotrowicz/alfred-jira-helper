require_relative 'bundle/bundler/setup'
require_relative 'handler'

query = ARGV[0] || ENV['jql']

print Handler.new.call(query)

require_relative 'bundle/bundler/setup'
require_relative 'handler'

query = ARGV[0]

print Handler.new.call(query)

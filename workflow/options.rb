require_relative 'bundle/bundler/setup'
require_relative 'handler'
require 'yaml'

config = YAML.load_file(File.expand_path('~/.config/jira.yml'))

workflow = Alfred3::Workflow.new

config.fetch('queries').each do |query|
  name = query.fetch('name')
  jql = query.fetch('jql')

  workflow
    .result
    .uid(name)
    .title(name)
    .arg(jql)
end

print workflow.output

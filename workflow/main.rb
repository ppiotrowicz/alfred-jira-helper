require_relative 'bundle/bundler/setup'
require 'alfred-3_workflow'
require 'yaml'
require 'time'
require_relative 'jira'
require_relative 'pretty_date'

workflow = Alfred3::Workflow.new
config = YAML.load_file(File.expand_path('~/.jira.yml'))

jira = Jira.new(config)
result = jira.filter_issues(ARGV[0], 30)
result.fetch('issues').each do |issue|
  key = issue.fetch('key')
  summary = issue.dig('fields', 'summary')
  status = issue.dig('fields', 'status', 'name')
  assignee = issue.dig('fields', 'assignee', 'displayName') || 'Unassigned'
  updated = issue.dig('fields', 'updated')
  updated_ago = PrettyDate.format(Time.parse(updated))
  url = config.fetch('url') + "browse/#{key}"

  workflow
    .result
    .uid(key)
    .title("#{key} · #{summary}")
    .subtitle("#{status} · #{assignee} · last updated: #{updated_ago}")
    .arg(url)
    .valid('yes')
    .cmd('Copy issue key', key)
end

print workflow.output

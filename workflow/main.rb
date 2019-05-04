require_relative 'bundle/bundler/setup'
require 'alfred-3_workflow'
require 'yaml'
require 'time'
require_relative 'jira'
require_relative 'pretty_date'
require_relative 'cache'

query = ARGV[0]
max_results = 30

cache = Cache.new(File.expand_path('~/.cache/ppiotrowicz-alfred-jira'), 5 * 60)

if (cached = cache.get(query))
  print cached
else
  workflow = Alfred3::Workflow.new

  config = YAML.load_file(File.expand_path('~/.config/jira.yml'))
  jira = Jira.new(config)
  result = jira.filter_issues(query, max_results)

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

  output = workflow.output
  cache.store(query, output)
  print output
end

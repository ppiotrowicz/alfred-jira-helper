require_relative 'bundle/bundler/setup'
require 'alfred'
require_relative 'jira'
require 'yaml'

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback
  config = YAML.load_file(File.expand_path('~/.jira.yml'))

  jira = Jira.new(config)
  result = jira.filter_issues(ARGV[0], 30)
  result.fetch('issues').each do |issue|
    key = issue.fetch('key')
    summary = issue.dig('fields', 'summary')
    fb.add_item(
      uid: key,
      title: "#{key} - #{summary}",
      arg: key,
      valid: 'yes'
    )
  end

  puts fb.to_alfred
end

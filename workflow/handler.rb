require 'alfred-3_workflow'
require 'yaml'
require 'time'
require_relative 'jira'
require_relative 'pretty_date'
require_relative 'cache'

class Handler
  MAX_RESULTS = 30
  CACHE_TTL = 5 * 60
  CACHE_LOCATION = '~/.cache/alfred-jira-helper'
  CONFIG_LOCATION = '~/.config/jira.yml'

  def call(query)
    cache = Cache.new(File.expand_path(CACHE_LOCATION), CACHE_TTL)

    if (cached = cache.get(query))
      cached
    else
      result = live(query)
      cache.store(query, result)
      result
    end
  end

  private

  def live(query)
    workflow = Alfred3::Workflow.new

    config = YAML.load_file(File.expand_path(CONFIG_LOCATION))
    jira = Jira.new(config)
    result = jira.filter_issues(query, MAX_RESULTS)

    result.fetch('issues').each { |issue| to_alfred_item(issue) }

    workflow.output
  end

  def to_alfred_item(issue, workflow)
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
end

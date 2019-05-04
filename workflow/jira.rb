require 'json'
require 'faraday'

class Jira
  def initialize(config)
    @base_url = config.fetch('url')
    @username = config.fetch('username')
    @password = config.fetch('password')
  end

  def filter_issues(jql, max_results)
    payload = {
      'jql' => jql,
      'maxResults' => max_results,
      'fields' => ['summary']
    }.to_json

    response = post('rest/api/2/search', payload)

    JSON.parse(response.body)
  end

  private
  
  def client
    Faraday.new(@base_url) do |conn|
      conn.adapter Faraday.default_adapter
      # conn.response :logger
      conn.basic_auth(@username, @password)
    end
  end

  def post(url, body)
    client.post do |req|
      req.url url
      req.headers['Content-Type'] = 'application/json'
      req.body = body
    end
  end
end

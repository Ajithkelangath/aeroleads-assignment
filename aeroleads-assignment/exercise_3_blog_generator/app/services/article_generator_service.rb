require 'httpx'
require 'json'

class ArticleGeneratorService
  API_URL = 'https://api.perplexity.ai/chat/completions'

  def initialize(api_key = ENV['PERPLEXITY_API_KEY'])
    @api_key = api_key
  end

  # Generates a blog article for the given title.
  def call(title)
    return "Mock content for #{title} (Missing API Key)" if @api_key.nil? || @api_key.empty?

    begin
      response = HTTPX.post(
        API_URL,
        headers: {
          'Authorization' => "Bearer #{@api_key}",
          'Content-Type' => 'application/json'
        },
        json: {
          model: 'sonar',
          messages: [
            { role: 'system', content: 'You are a helpful assistant that writes blog posts.' },
            { role: 'user', content: "Write a blog post about: #{title}" }
          ]
        }
      )

      if response.status == 200
        json = JSON.parse(response.body)
        json.dig('choices', 0, 'message', 'content') || 'No content generated.'
      else
        "Error: #{response.status} - #{response.body}"
      end
    rescue => e
      "Exception: #{e.message}"
    end
  end
end

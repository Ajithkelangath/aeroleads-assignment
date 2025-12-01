require 'httpx'
require 'json'

class ArticleGeneratorService
  API_KEY = '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'
  API_URL = 'https://api.perplexity.ai/chat/completions'

  def self.generate(title)
    return "Mock content for #{title}" if API_KEY.blank?

    begin
      response = HTTPX.post(
        API_URL,
        headers: {
          'Authorization' => "Bearer #{API_KEY}",
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
        json.dig('choices', 0, 'message', 'content') || "No content generated."
      else
        "Error: #{response.status} - #{response.body}"
      end
    rescue => e
      "Exception: #{e.message}"
    end
  end
end

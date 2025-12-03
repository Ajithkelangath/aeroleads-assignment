require_relative '../autodialer/app/services/article_generator_service'

# Manually load .env file since dotenv gem might not be available
# Assuming .env is in the root of the workspace (sample_second/.env)
env_path = File.expand_path('../.env', __dir__)
# If not found there, try one level up if we are in exercise_3...
if !File.exist?(env_path)
   env_path = File.expand_path('../../.env', __dir__)
end

if File.exist?(env_path)
  puts "Loading .env from #{env_path}"
  File.foreach(env_path) do |line|
    next if line.strip.start_with?('#') || line.strip.empty?
    key, value = line.strip.split('=', 2)
    if key && value
      # Remove quotes if present
      value = value.strip.gsub(/^["']|["']$/, '')
      ENV[key] = value
    end
  end
else
  puts "Warning: .env file not found at #{env_path}"
end

# List of article titles (data science topics)
TITLES = [
  'Data Science Basics: An Introduction',
  'Exploring Data Visualization Techniques',
  'Machine Learning Algorithms Explained',
  'Deep Learning for Natural Language Processing',
  'Time Series Analysis in Python',
  'Big Data Processing with Spark',
  'Statistical Methods for Data Scientists',
  'Data Cleaning and Preprocessing Best Practices',
  'Building Recommender Systems',
  'Ethics and Bias in Data Science'
]

service = ArticleGeneratorService.new

# Path to seeds file (relative to this script)
# Script is in exercise_3_blog_generator/
# autodialer is in autodialer/
seeds_path = File.expand_path('../../autodialer/db/seeds.rb', __dir__)

puts "Starting article generation..."
puts "API Key present: #{!ENV['PERPLEXITY_API_KEY'].nil?}"

File.open(seeds_path, 'w') do |file|
  file.puts "# Auto-generated AI articles"
  TITLES.each do |title|
    puts "Generating article for: #{title}"
    content = service.call(title)
    
    # Simple escaping for the seed file string
    escaped_content = content.gsub('"', '\\"').gsub('#{', '\\#{')
    
    file.puts "Post.create!(title: \"#{title}\", content: \"#{escaped_content}\")"
    sleep 1 # Rate limiting precaution
  end
end

puts "Finished generating #{TITLES.size} articles and updated seeds.rb"

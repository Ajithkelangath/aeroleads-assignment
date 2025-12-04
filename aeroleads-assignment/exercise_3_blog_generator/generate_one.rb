require_relative 'app/services/article_generator_service'

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

# Path to seeds file
seeds_path = File.expand_path('db/seeds.rb', __dir__)

puts "Starting article generation..."
puts "API Key present: #{!ENV['PERPLEXITY_API_KEY'].nil?}"

File.open(seeds_path, 'w') do |file|
  file.puts "# Auto-generated AI articles"
  TITLES.each do |title|
    puts "Generating article for: #{title}"
    content = service.call(title)
    
    # Simple escaping
    escaped_content = content.gsub('"', '\\"').gsub('#{', '\\#{')
    
    file.puts "Post.create!(title: \"#{title}\", content: \"#{escaped_content}\")"
    sleep 1 # Rate limiting
  end
end

puts "Finished generating #{TITLES.size} articles and updated seeds.rb"

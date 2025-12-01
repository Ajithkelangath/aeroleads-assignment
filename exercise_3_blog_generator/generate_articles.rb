# generate_articles.rb
topics = [
  "Introduction to Machine Learning",
  "Deep Learning vs Machine Learning",
  "Natural Language Processing Applications",
  "Computer Vision in Healthcare",
  "Big Data Analytics Trends 2025",
  "Reinforcement Learning Explained",
  "Ethics in AI and Data Science",
  "Python for Data Analysis",
  "Understanding Neural Networks",
  "The Future of Generative AI"
]

puts "Starting article generation..."

topics.each_with_index do |topic, index|
  puts "Generating article #{index + 1}/10: #{topic}..."
  begin
    ArticleGeneratorService.new(topic).call
    puts "  -> Success!"
  rescue => e
    puts "  -> Failed: #{e.message}"
  end
  sleep(2) # Avoid rate limits
end

puts "All articles generated."

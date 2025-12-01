# Generate 10 articles
titles = [
  "Introduction to Ruby on Rails",
  "Understanding Python Decorators",
  "Getting Started with React",
  "The Future of AI in Coding",
  "Active Record vs DataMapper",
  "How to Scrape Websites Responsibly",
  "Optimizing SQL Queries",
  "Building REST APIs",
  "Docker for Beginners",
  "Why Testing Matters"
]

puts "Seeding articles..."
titles.each do |title|
  puts "Creating: #{title}"
  # Use simple content for now to avoid API calls during seed
  content = "This is a comprehensive article about #{title}. Stay tuned for more detailed content!"
  Post.create!(title: title, content: content)
end
puts "Done seeding #{Post.count} articles."

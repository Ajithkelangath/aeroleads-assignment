# generate_one.rb
puts "Generating 1 article..."
begin
  ArticleGeneratorService.new("Data Science 101").call
  puts "Success!"
rescue => e
  puts "Failed: #{e.message}"
end

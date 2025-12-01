class PostsController < ApplicationController
  def index
    @posts = Post.order(created_at: :desc)
    @post = Post.new
  end

  def create
    if params[:titles].present?
      titles = params[:titles].split("\n").reject(&:blank?)
      titles.each do |title|
        content = ArticleGeneratorService.generate(title)
        Post.create(title: title, content: content)
      end
      flash[:notice] = "Generated #{titles.count} articles."
    else
      flash[:alert] = "No titles provided."
    end
    redirect_to posts_path
  end
end

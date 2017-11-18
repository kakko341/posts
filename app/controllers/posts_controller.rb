class PostsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    @post = current_user.posts.build(posts_params)
    if @post.save
      flash[:success] = "ポストに投稿しました。"
      redirect_to root_url
    else
      @posts = current_user.posts.order('created_at DESC').page(params[:page])
      flash.now[:danger] = "ポスト投稿に失敗しました。"
      render 'toppages/index'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "ポストを削除しました。"
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def posts_params
    params.require(:post).permit(:content)    
  end
  
  def current_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to root_url
    end
  end

end

class RetweetsController < ApplicationController
  before_action :require_user_logged_in
  
  def new
    @post = Post.find(params[:post_id])
    @retweet = Retweet.new
  end

  def create
    @post = Post.find(params[:post_id])
    @retweet = current_user.retweets.build(retweet_params)
    @retweet.post_id = @post.id
    if @retweet.save!
      flash[:success] = "返信しました。"
      redirect_to root_url
    else
      flash.now[:danger] = "返信に失敗しました。"
      render :new
    end
  end

  def destroy
    @retweet = Retweet.find(params[:id])
    @retweet.destroy
    flash[:success] = "返信を削除しました。"
    redirect_back(fallback_location: root_url)
  end
  
  private
  
  def retweet_params
    params.require(:retweet).permit(:content)
  end
end

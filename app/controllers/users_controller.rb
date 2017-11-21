class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [ :index, :show, :followings, :followers ]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = "ユーザーを登録しました。"
      redirect_to @user
    else
      flash.now[:danger] = "ユーザーの登録に失敗しました。"
      render :new
    end
  end
  
  def retweets
    @user = User.find(params[:id])
    @retweets = @user.posts.page(params[:page])
    counts(@posts)
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  private
  
  def user_params
    params.require(:user).permit( :name, :email, :password, :password_confirmation, :image )
  end
  
  def retweet_params
    params.require(:retweet).permit(:content)
  end
  
end

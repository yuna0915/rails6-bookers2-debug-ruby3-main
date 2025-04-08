class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :set_user, only: [:follow, :unfollow]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @currentUserEntry = Entry.where(user_id: current_user.id)
    #現在ログインしているユーザーが参加しているルームの一覧
    @userEntry = Entry.where(user_id: @user.id)
    #他のユーザーが参加しているルームの一覧
    unless @user.id == current_user.id
    #自分のプロフィールページを見ている場合に処理をスキップする
      @currentUserEntry.each do |cu| 
        @userEntry.each do |u| 
          if cu.room_id == u.room_id 
    #cu.room_id:現在のユーザーが参加しているルームのID
    #u.room_id:他のユーザーが参加しているルームのID
    #この条件が真（両方が同じルームに参加している場合）なら、そのルームを使う準備をする
            @isRoom = true
    #「同じルームに参加している」ことを示すフラグ
            @roomId = cu.room_id
    #同じルームに参加している場合、そのルームのIDを保存しておく
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
    #@isRoom がfalseなら、新しいルームを作る準備として、@room = Room.new で新しい空のルームを作成
      end
    end
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

end

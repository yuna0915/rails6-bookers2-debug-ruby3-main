class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_non_related, only: [:show]

  def create
    @room = Room.create
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    #現在のユーザーが作成したルームに参加すること
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id))
    #フォームから送信されたデータの中から、user_id と room_id を取り出して許可している
    # .merge(room_id: @room.id) は新しい部屋のIDを追加するためのもの
    redirect_to "/rooms/#{@room.id}"
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
    #ルーム内のメッセージを表示できるようになる
      @message = Message.new
      @entries = @room.entries
    #ルーム内の参加ユーザー情報を表示できるようになる
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

    def reject_non_related
      room = Room.find(params[:id])
      user = room.entries.where.not(user_id: current_user.id).first.user
      unless (current_user.following?(user)) && (user.following?(current_user))
    #現在のユーザーとそのユーザーが相互にフォローしていない場合、アクセスを拒否する
        redirect_to books_path
      end
    end
end

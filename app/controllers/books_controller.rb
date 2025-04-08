class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index
    to = Time.current.at_end_of_day
    #今日の23:59:59のこと
    from = (to - 6.day).at_beginning_of_day
    #今日から6日前にさかのぼる、その日の0:00:00にする
    @books = Book.includes(:favorited_users).
    #本と本にいいねした人達のデータを取ってくる
      sort_by {|x|
        x.favorited_users.includes(:favorites).where(created_at: from...to).size
      }.reverse
    #sort_by:どの順番で並べるか、`x` は1冊の本のこと
    #本(x)に「いいね」したユーザーを集める
    #その中から「いいねした時間が過去1週間」のものだけ選ぶ
    #.size → その数を数える（つまり「過去1週間のいいねの数」）
    #.reverse を使うと、多い順（いいねが多い本が上に）になる
    @book = Book.new

  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end

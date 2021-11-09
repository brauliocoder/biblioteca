class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy loan_switch ]
  before_action :borrow_unborrow, only: %i[ loan_switch ]

  # GET /books or /books.json
  def index
    
    # Filtro
    if params[:f]
      # @books = Book.where(:status => params[:s])
      @q = (Book.where(:status => params[:f])).ransack(params[:f])
      @books = @q.result
      
    # Busqueda
    elsif params[:q]
      # @books = Book.where('lower(title) = ?', params[:q].downcase)
      @q = Book.ransack(params[:q])
      @books = @q.result

    # Mostrar todo
    else
      # @books = Book.all.order(:title)
      @q = (Book.all.order(:title)).ransack(params[:t])
      @books = @q.result
    end
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  def loan_switch
    redirect_to :action => "index"
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :author, :status, :loan_date, :return_date)
    end

    def borrow_unborrow
      if @book.status
        @book.update_attribute(:status, false)
  
        @book.update_attribute(:loan_date, DateTime.now)
        @book.update_attribute(:return_date, nil)
  
      #Libro prestado
      else
        @book.update_attribute(:status, true)
        @book.update_attribute(:return_date, DateTime.now)
      end
    end
end

class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @all_ratings_hash = Hash[@all_ratings.collect { |r| [r, true] }]

    # if there are arguments in session and not in params, we need to save them to redirect_params and do redirect
    # redirect_params = Hash.new
    puts 'hi1'
    if params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]:
      redirect_params[:sort] = session[:sort]
    end
    puts redirect_params

    if params[:ratings]:
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      redirect_params[:ratings] = session[:ratings]
    else
      redirect_params[:ratings] = @all_ratings_hash
    end
    puts redirect_params

    # if not redirect_params.empty?
    #   redirect_to(movie_path redirect_params)
    # end
    puts 'hi4'

    if params[:sort]
      @movies = Movie.order(params[:sort])
    end

    if params[:ratings]
      @movies.where!({rating: params[:ratings].keys})
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

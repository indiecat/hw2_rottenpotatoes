class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_all_ratings
    if params[:sort]
      session.merge! :sort => params[:sort]
    end
    sort_column = session[:sort]
    @checked_ratings = []
    if params[:ratings]
      session.merge! :ratings => params[:ratings]
      @checked_ratings = params[:ratings].keys
    else
      if session[:ratings]
        @checked_ratings = session[:ratings].keys
      end
    end
    @movies = Movie.order(sort_column).find_all_by_rating(@checked_ratings)
    if (!params[:sort] || !params[:ratings])
      flash.keep
      redirect_to movies_path(params.merge :sort => session[:sort], :ratings => session[:ratings])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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

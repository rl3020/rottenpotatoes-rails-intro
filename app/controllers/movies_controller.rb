class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.all_ratings
    
    @ratings_to_show = params[:ratings].nil? ? @all_ratings : params[:ratings].keys
    
    @movies = Movie.with_ratings(@ratings_to_show)
    
    @movies_title_css = 'text-primary'
    @release_date_css = 'text-primary'
    redirect = false
    
    puts "ratings_to_show"
    puts @ratings_to_show
    
    puts "movies"
    puts @movies
    
    
    
    if params.has_key?(:to_sort)
      @clicked = params[:to_sort]
      session[:to_sort] = params[:to_sort]
      
      puts 'params has key :to_sort'
      puts params[:to_sort]
      
      puts 'storing params[to_sort ] in session'
      puts session[:to_sort]
      
    elsif session.has_key?(:to_sort)
      @clicked = session[:to_sort]
      redirect = true
      
      puts 'session has key :to_sort'
      puts @clicked
    else
      puts 'no one has key :to_sort'
      
      @clicked = ''
    end
    

    if params.has_key?(:ratings)
      @ratings_to_show = params[:ratings]
      session[:ratings] = @ratings_to_show
      
      puts 'params has :ratings'
      puts params[:ratings]
      puts 'after storing @ratings to show in session'
      puts @ratings_to_show
      
      
    elsif session.has_key?(:ratings)
      @ratings_to_show = session[:ratings]
      redirect = true
      
      puts 'sessions has :ratings'
      puts session[:ratings]
      
    end
    
    if @clicked == 'movie_title'
      @movies_title_css = 'hilite text-primary'
      @release_date_css = 'text-primary'
      
    elsif @clicked == 'release_date'
      @release_date_css = 'hilite text-primary'
      @movies_title_css = 'text-primary'
      
    else
      @movies_title_css = 'text-primary'
      @release_date_css = 'text-primary'
    end
    
    
    if @clicked == 'movie_title'
      @movies = @movies.order(:title)
    elsif @clicked == 'release_date'
      @movies = @movies.order(:release_date)   
      
    end
    
    if redirect
      puts 'redirecting to... '
      puts movies_path
      puts @ratings_to_show
      puts @clicked
      
      redirect_to movies_path(:ratings => @ratings_to_show, :to_sort => @clicked)
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

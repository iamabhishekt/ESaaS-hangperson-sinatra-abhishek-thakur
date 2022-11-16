require 'sinatra/base'
require 'sinatra/flash'
require_relative './lib/wordguesser_game.rb'

class WordGuesserApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || WordGuesserGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || WordGuesserGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = WordGuesserGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in WordGuesserGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    if params[:guess].length != 1
      flash[:message] = "Invalid guess."
    else
      letter = params[:guess].to_s[0] #get first letter
      ### YOUR CODE HERE ###
      if @game.guesses.include? letter or @game.wrong_guesses.include? letter
        flash[:message] = "You have already used that letter."
      elsif letter == nil or letter == ""
        flash[:message] = "Invalid guess."
      else
        @game.guess letter
      end
    redirect '/show' # always redirect to /show
    end
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in WordGuesserGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use the instance variables
  # wrong_guesses and word_with_guesses from @game.
  get '/show' do
    ### YOUR CODE HERE ###
    # if @game.word == '' # no word yet
    #   redirect '/new' # go to new game
    # else # word exists
      result = @game.check_win_or_lose # :win, :lose, :play
      if result == :win # win
        session[:state] = :win # set session state to win
        redirect '/win' # redirect to win page
      elsif result == :lose # lose
        session[:state] = :lose # save state
        redirect '/lose' # redirect to lose page
      else # play
        erb :show # You may change/remove this line
      # end
    end
  end
  
  get '/win' do
    ### YOUR CODE HERE ###
    if @game.check_win_or_lose == :win # not win
      erb :win # You may change/remove this line
    else # win
      redirect '/show' # redirect to show page
    end
  end
  
  get '/lose' do
    ### YOUR CODE HERE ###
    if @game.check_win_or_lose == :lose # not lose
      erb :lose # You may change/remove this line
    else # lose
      redirect '/show' # redirect to show page
    end
  end
end

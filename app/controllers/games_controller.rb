require 'open-uri'
require 'json'

class GamesController < ApplicationController
  
  VOYELS = ["A", "E", "I", "O", "U", "Y"]
  CONSONNES = ["B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z"]

  def new
    consonnes = Array.new(5) { CONSONNES.sample }
    voyels = Array.new(5) { VOYELS.sample }
    @letters = consonnes + voyels
    @letters = @letters.shuffle!
  end

  def score
    attempt = params[:attempt]
    grid = params[:letters]
    if included?(attempt.upcase, grid)
      if attempt_is_english?(attempt)
        @result = "Congrats, #{attempt} is a valid word"
      else
        @result = "Sorry, #{attempt} is not an english word"
      end
    else 
      @result = "Sorry, #{attempt} is not in the grid"
    end


  end

  def attempt_is_english?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    attempt_serialized = open(url).read
    JSON.parse(attempt_serialized)["found"]
  end

  def included?(attempt, grid)
    attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end
end

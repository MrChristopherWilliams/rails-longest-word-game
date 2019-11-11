class GamesController < ApplicationController
  def new
    @letters = (0...9).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @start_time = params[:start_time]
    @end_time = params[:end_time]
    @result = {}
    run_game(@word, @letters, @start_time, @end_time)
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    found = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)["found"]
    time = end_time - start_time
    in_grid = in_grid?(attempt, grid)
    if found && in_grid
      @result = { message: "Well done", score: attempt.length / (time + 1), time: time }
    elsif found && !in_grid
      @result = { message: "Not in the grid", score: 0, time: time }
    else @result = { message: "Not an english word", score: 0, time: time }
    end
    @result
  end

  def in_grid?(attempt, grid)
    upcased_attempt = attempt.upcase.chars
    upcased_attempt.all? do |letter|
      upcased_attempt.count(letter) <= grid.count(letter)
    end
  end
end

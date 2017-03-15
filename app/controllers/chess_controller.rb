class ChessController < ApplicationController
  def index
    @available_games = Game.available
    @full_games = Game.all - @available_games
    flash[:notice] = nil
  end
end

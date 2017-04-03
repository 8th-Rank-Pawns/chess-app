class ChessController < ApplicationController
  def index
    @games = Game.all
    @my_games = []
    @finished_games = []
    if current_user
      @games.each do |game|
        @my_games << game if (game.white_player == current_user.id || game.black_player == current_user.id) && game.finished == false
        @finished_games << game if (game.white_player == current_user.id || game.black_player == current_user.id) && game.finished == true
      end
    end
    @available_games = Game.available
    @full_games = @games - @available_games
    flash[:notice] = nil
    flash[:alert] = nil
  end
end

class ChessController < ApplicationController
  def index
		@available_games = Game.available
  end
end
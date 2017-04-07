class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params.merge(white_player: current_user.id))
    @game.populate_board!
    redirect_to game_path(@game)
  end

  def show
    @game = Game.find_by_id(params[:id])
    data = params[:p_type]
    return render text: 'Not Found', status: :not_found if @game.blank?
    until data.nil?
      @game.pieces.where(type: 'Pawn', vertical_position: 1).first.try(:update_attributes, type: data)
      @game.pieces.where(type: 'Pawn', vertical_position: 8).first.try(:update_attributes, type: data)
      data = params[:p_type] = nil
      return redirect_to game_path(@game)
    end
    flash_notices
  end

  def update
    @game = Game.find(params[:id])
    if @game.black_player.nil? && params[:concede].blank?
      @game.update_attributes(black_player: current_user.id)
      return redirect_to game_path(@game)
    end
    return unless params[:concede] == 'true'
    @game.update_attributes(finished: true)
    redirect_to root_path
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

  def flash_notices
    flash[:notice] = nil
    flash[:alert] = nil
    flash[:notice] = @game.turn ? 'White Player\'s turn' : 'Black Player\'s turn'
    if @game.checkmate!('white')
      flash[:notice] = nil
      @game.update_attributes(finished: true)
      return flash[:alert] = 'Checkmate. Black Player Wins!'
    end
    if @game.checkmate!('black')
      flash[:notice] = nil
      @game.update_attributes(finished: true)
      return flash[:alert] = 'Checkmate. White Player Wins!'
    end
    flash[:alert] = 'Black King Check!' if @game.check?('black')
    flash[:alert] = 'White King Check!' if @game.check?('white')
  end
end

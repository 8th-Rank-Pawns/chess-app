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

    until data.nil?
      @game.pieces.where(type: 'Pawn', vertical_position: 1).first.try(:update_attributes, type: data)
      @game.pieces.where(type: 'Pawn', vertical_position: 8).first.try(:update_attributes, type: data)
      data = params[:p_type] = nil
      redirect_to game_path(@game)
    end

    return render text: 'Not Found', status: :not_found if @game.blank?
    flash[:notice] = nil
    if @game.check?('black')
      flash[:notice] = 'Black King Check!'
    elsif @game.check?('white')
      flash[:notice] = 'White King Check'
    end

  end

  def update
    @game = Game.find(params[:id])
    if @game.black_player.nil?
      @game.update_attributes(black_player: current_user.id)
    end
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end

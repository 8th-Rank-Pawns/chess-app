class Game < ActiveRecord::Base
  scope :available, -> { where("white_player is null or black_player is null")  } #Game.available

end

class Game < ActiveRecord::Base
  scope :available, -> { where('black_player IS NULL OR white_player IS NULL') }
  has_many :users
  has_many :pieces
end

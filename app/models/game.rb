class Game < ActiveRecord::Base
	scope :available, -> { where('black_player IS NULL OR white_player IS NULL') }
end
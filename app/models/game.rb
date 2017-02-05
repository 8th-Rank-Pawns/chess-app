class Game < ActiveRecord::Base
  scope :available, -> { where(black_id :null).or(where(white_id :null)) }

end

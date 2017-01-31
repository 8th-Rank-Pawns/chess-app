class Game < ActiveRecord::Base
  scope :available, -> { where(black_id is null or white_id is null) }
  #scope :available, -> { where(white_id: nil) }

end

#http://stackoverflow.com/questions/17192829/does-rails-4-have-support-for-or-queries
#Note, null for sql.
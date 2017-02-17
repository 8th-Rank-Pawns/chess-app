FactoryGirl.define do
  factory :pawn do
  end
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password 'secretPassword'
    password_confirmation 'secretPassword'
  end

  factory :game do
    name 'Player 1'
  end

  factory :fullgame, class: Game do
    name 'full game'
    white_player { FactoryGirl.create(:user).id }
    black_player { FactoryGirl.create(:user).id }
  end

  factory :piece do
  end

  factory :king do
  end

  factory :queen do
  end

  factory :rook do
  end

  factory :knight do
  end

  factory :bishop do
  end

  factory :pawn do
  end
end

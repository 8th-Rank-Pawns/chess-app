FactoryGirl.define do
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
end

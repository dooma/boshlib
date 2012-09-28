FactoryGirl.define do
  # Create simplest user
  factory :user do
    email "test@test.com"
    username "test"
    password "parola123"
    password_confirmation "parola123"
  end
end

FactoryGirl.define do
  # Create simplest user
  factory :user do
    email "test@test.com"
    username "test"
    password "parola123"
    password_confirmation "parola123"
  end

  factory :book do
    author "William Shakespeare"
    title "Romeo&Julieta"
    description "A story about love"
    year "1923"
    price "200"
    units 1
    hire_status true
  end
end

FactoryGirl.define do
  factory :user do
    password = Faker::Internet.password
    name                    { Faker::Name.name }
    email                   { Faker::Internet.email }
    password                { password }
    password_confirmation   { password }
  end
  
  factory :invalid_user, class: "User" do
    password = " "
    name                    { Faker::Name.name }
    email                   { Faker::Internet.email }
    password                { password }
    password_confirmation   { password }
  end
end
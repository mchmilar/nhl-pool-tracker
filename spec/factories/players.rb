FactoryGirl.define do
  factory :player do
    password = Faker::Internet.password
    name                    { Faker::Name.name }
  end

end
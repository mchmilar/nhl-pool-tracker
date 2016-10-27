FactoryGirl.define do
  factory :team do
    teamFullName                    { Faker::Name.name }
    teamAbbrev             {  "edm" }
  end

  factory :invalid_team do
    teamFullName                    { " " }
    teamAbbrev             { "3s3j" }
  end
end
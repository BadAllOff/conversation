FactoryGirl.define do

  factory :user1 do
    user_id                     1
    email                       "user1@example.com"
    first_name                  "Stan"
    last_name                   "Lee"
    provider                    "facebook"
    uid                         "10001001010100"
  end

  factory :user2 do
    user_id                     2
    email                       "user2@example.com"
    first_name                  "Michael"
    last_name                   "Jackson"
    provider                    "twitter"
    uid                         "10001001010100"
  end

end

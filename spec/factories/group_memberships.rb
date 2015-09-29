FactoryGirl.define do

  factory :group_membership do
    group_id        1
    user_id         1
    status          "pending"
    admission_time  Time.now.to_s
    accepted_by     2
  end

end
FactoryGirl.define do

  factory :group do
    group_name      "Some group name"
    topics          "Politics, Religion, Love"
    starts_at       Time.now.to_s
    ends_at         Time.now+1.hour
    venue           "Maiden Tower"
    max_members     15
    user_id         1
    privacy         "public"
    members_counter 2
    latitude        '40.36603994719198'
    longitude       '49.83751684427261'
    gmap_zoom       14
  end

end



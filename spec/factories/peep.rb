FactoryGirl.define do
  factory :peep do
    user
    content "Hello everyone"
    created_at Time.now
  end
end
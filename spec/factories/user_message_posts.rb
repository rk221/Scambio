FactoryBot.define do
  factory :user_message_post do
    user
    subject {"testsubject"}
    message {"<HTML>test</HTML>"}
    already_read {false}
  end
end

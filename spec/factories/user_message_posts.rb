FactoryBot.define do
  factory :user_message_post do
    user_id {1}
    subject {"testsubject"}
    message {"<HTML>test</HTML>"}
    already_read_flag {false}
  end
end

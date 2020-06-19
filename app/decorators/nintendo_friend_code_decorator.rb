class NintendoFriendCodeDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def friend_code 
    split_codes = object.friend_code.scan(/.{1,#{4}}/)
    "#{split_codes[0]}-#{split_codes[1]}-#{split_codes[2]}"
  end

end

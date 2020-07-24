class UserGameRankDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def rank_name
    case object.rank
    when -2 then
      UserGameRank.human_attribute_name(:red)
    when -1 then
      UserGameRank.human_attribute_name(:orange)
    when 0 then
      UserGameRank.human_attribute_name(:gray)
    when 1 then
      UserGameRank.human_attribute_name(:white)
    when 2 then
      UserGameRank.human_attribute_name(:green)
    when 3 then
      UserGameRank.human_attribute_name(:gold)
    when 4 then
      UserGameRank.human_attribute_name(:diamond)
    else
      nil
    end
  end

end

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
      'レッド'
    when -1 then
      'オレンジ'
    when 0 then
      'グレー'
    when 1 then
      'ホワイト'
    when 2 then
      'グリーン'
    when 3 then
      'ゴールド'
    when 4 then
      'ダイヤ'
    else
      nil
    end
  end

end

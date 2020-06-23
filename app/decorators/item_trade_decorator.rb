class ItemTradeDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def trade_deadline
    subtract_second = object.trade_deadline - Time.zone.now 
    return "ERROR" if subtract_second < 0
    
    trade_deadline_message = 'あと'

    calc_time = calc_second_to_hour(subtract_second)
    return trade_deadline_message + "#{calc_time}時間" if calc_time > 0

    calc_time = calc_second_to_minute(subtract_second)
    return trade_deadline_message + "#{calc_time}分" if calc_time > 0
    
    return trade_deadline_message + "#{subtract_second}秒"
  end

  decorates_association :user_game_rank

  private
  def calc_second_to_hour(second)
    return (second / (60 * 60)).floor
  end

  def calc_second_to_minute(second)
    return (second / 60).floor
  end 
end

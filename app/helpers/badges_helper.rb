module BadgesHelper
    def trade_badges(user_badges)
        badge_tags = ''
        user_badges.wearing.each do |user_badge|
            data_hash = {id: "user_badge_#{user_badge.id}", name: "#{user_badge.badge.name}", description: simple_format(user_badge.badge.description)} # simple_format内にhがついていないのは、rawを通す為、戻される
            if user_badge.badge.image_icon.present?
                badge_tags += image_tag(user_badge.badge.image_icon_url, {class: 'badge-image', "v-on:mouseover": "onMouseOver($event)", 'v-on:mouseleave': 'onMouseLeave($event)', data: data_hash})
            else  
                badge_tags += tag.div(class: "badge-name user-game-rank-#{user_badge.badge.rank_condition}", data: data_hash, "v-on:mouseover": "onMouseOver($event)", 'v-on:mouseleave': 'onMouseLeave($event)') do
                    "#{user_badge.badge.name}"
                end
            end
        end
        raw(badge_tags)
    end
end
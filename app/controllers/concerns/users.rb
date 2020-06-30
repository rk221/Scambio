module Users
    extend ActiveSupport::Concern

    include Errors

    def confirm_user(obj)
        obj.user_id == current_user.id
    end

end

module UsersHelper
    def admin_user
        if current_user.admin_flag?
            redirect_to root_path #後々403エラーページに変更する
        end
    end
end

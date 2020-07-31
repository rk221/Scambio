module UserMessagePostsHelper
    def unready_read_exist
        current_user.user_message_posts.where(already_read: false).exists?
    end
end

class Users::UserMessagePostsController < UsersController
    before_action :user_auth

    def index
        @user_message_posts = current_user.user_message_posts.decorate
    end

    def show 
        @user_message_post = current_user.user_message_posts.find(params[:id])
        @user_message_post.update!(already_read: true)
        @user_message_post = @user_message_post.decorate
    end

    def all_read
        current_user.user_message_posts.where(already_read: false).update_all(already_read: true)
        redirect_to action: :index
    end
end

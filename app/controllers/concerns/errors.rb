module Errors
    extend ActiveSupport::Concern

    def redirect_to_error(warning_message = t('flash.error'))
        redirect_to root_path ,warning: warning_message
    end

    def redirect_to_permit_error
        redirect_to_error(t('flash.permit_error'))
    end
end

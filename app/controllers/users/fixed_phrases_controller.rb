class Users::FixedPhrasesController < BaseUsersController
    def index 
        @fixed_phrases = current_user.fixed_phrases
    end
    
    def show 
        @fixed_phrase = current_user.fixed_phrases.find(params[:id])
    end

    def new 
        @fixed_phrase = FixedPhrase.new
    end

    def create
        @fixed_phrase = FixedPhrase.new(fixed_phrase_params)

        if @fixed_phrase.save
            redirect_to action: :show, id: @fixed_phrase, user_id: current_user.id, notice: t('flash.create')
        else
            render :new
        end
    end

    def edit 
        @fixed_phrase = current_user.fixed_phrases.find(params[:id])
    end

    def update 
        @fixed_phrase = current_user.fixed_phrases.find(params[:id])

        if @fixed_phrase.update(fixed_phrase_params)
            redirect_to action: :show, id: @fixed_phrase, user_id: current_user.id, notice: t('flash.update')
        else
            render :edit
        end
    end

    def destroy
        @fixed_phrase = current_user.fixed_phrases.find(params[:id])

        @fixed_phrase.destroy!
        redirect_to action: :index, user_id: current_user.id, notice: t('flash.destroy')
    end

    private

    def fixed_phrase_params
        params.require(:fixed_phrase).permit(:name, :text).merge(user_id: current_user.id)
    end
end

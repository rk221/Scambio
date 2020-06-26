class FixedPhrasesController < ApplicationController
    def index 
        @fixed_phrases = FixedPhrase.where(user_id: current_user.id)
    end
    
    def show 
        @fixed_phrase = current_user.fixed_phrases.find(params[:id])
    end

    def new 
        @fixed_phrase = FixedPhrase.new
    end

    def create
        @fixed_phrase = FixedPhrase.new(fixed_phrase_params)
        @fixed_phrase.user_id = current_user.id

        if @fixed_phrase.save
            redirect_to fixed_phrase_path(@fixed_phrase), notice: t('flash.create')
        else
            render :new
        end
    end

    def edit 
        @fixed_phrase = current_user.fixed_phrases.find(params[:id])
    end

    def update 
        @fixed_phrase = FixedPhrase.find(params[:id])
        
        return redirect_to fixed_phrases_path, notice: t('flash.error') unless @fixed_phrase.user_id == current_user.id #ユーザ不一致

        if @fixed_phrase.update(fixed_phrase_params)
            redirect_to fixed_phrase_path(@fixed_phrase), notice: t('flash.update')
        else
            render :edit
        end
    end

    def destroy
        @fixed_phrase = FixedPhrase.find(params[:id])

        return redirect_to fixed_phrases_path, notice: t('flash.error') unless @fixed_phrase.user_id == current_user.id #ユーザ不一致

        @fixed_phrase.destroy
        redirect_to fixed_phrases_path, notice: t('flash.destroy')
    end

    private

    def fixed_phrase_params
        params.require(:fixed_phrase).permit(:name, :text)
    end
end

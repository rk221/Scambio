module PagenationsHelper
    def pagenate(active_record_relations)
        pagenations = hash_pages(active_record_relations.now_page, active_record_relations.total_page)
        render partial: 'shared/pagenation', locals: {pagenations: pagenations}
    end

    def hash_pages(now_page, total_page)
        pagenations = {} # {リンクの文字列: 飛ぶページ} ...

        if total_page > 1
            if now_page > 1 # 1ページではない場合にバックのリンクを追加する
                pagenations.store("<<", "1") 
                pagenations.store("<", (now_page - 1).to_s) 
            end
            
            (1..3).reverse_each do |i|
                pagenations.store("#{now_page - i}", (now_page - i).to_s) if now_page - i >= 1
            end
            
            pagenations.store("#{now_page}", false)

            (1..3).each do |i|
                pagenations.store("#{now_page + i}", (now_page + i).to_s) if now_page + i <= total_page
            end

            if now_page < total_page # 最終ページではない場合にネクストのリンクを追加する
                pagenations.store(">", (now_page + 1).to_s)
                pagenations.store(">>", (total_page).to_s) 
            end
        else
            pagenations.store("1", false)
        end

        pagenations
    end

    # ページを変更する時のパラメータ（ヘルパー）
    def page_redirect_params(page)
        params[:page] = page
        params.permit!
    end
end
module Pagenation
    extend ActiveSupport::Concern
  
    class ActiveRecord::Relation
        attr_reader :now_page, :total_count, :total_page

        NUMBER_OF_OUTPUT_LINES = 10 # １ページの件数

        def page(page_params = '1')
            @now_page = page_to_i(page_params)
            @total_count = all.size
            @total_page = (@total_count.to_f / NUMBER_OF_OUTPUT_LINES.to_f).ceil # 割った結果を切り上げし、1から始まるページ数を適切に算出
            all.limit(NUMBER_OF_OUTPUT_LINES).offset((@now_page - 1) * NUMBER_OF_OUTPUT_LINES) # 自分自身のオブジェクトを、表示する部分だけ抽出したものを返す
        end

        private

        def page_to_i(page_params)#整数の場合 数値変換し、返す 違う場合 1 を返す
            /\A[0-9]+\z/.match?(page_params) ? page_params.to_i : 1
        end
    end
end 
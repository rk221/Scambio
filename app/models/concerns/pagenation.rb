module Pagenation
    extend ActiveSupport::Concern
  
    included do
        NUMBER_OF_OUTPUT_LINES = 1 # １ページの件数

        scope :page, -> (page_params = '1') do 
            @now_page = self.page_to_i(page_params)
            @total_count = all.size
            @total_page = (@total_count.to_f / NUMBER_OF_OUTPUT_LINES.to_f).ceil # 割った結果を切り上げし、1から始まるページ数を適切に算出
            all.limit(NUMBER_OF_OUTPUT_LINES).offset((@now_page - 1) * NUMBER_OF_OUTPUT_LINES).extending do # 自分自身のオブジェクトを、表示する部分だけ抽出したものを返す
                attr_reader :now_page, :total_count, :total_page
            end
        end
    end

    class_methods do
        def page_to_i(page_params)#整数の場合 数値変換し、返す 違う場合 1 を返す
            /\A[0-9]+\z/.match?(page_params) ? page_params.to_i : 1
        end
    end
end 
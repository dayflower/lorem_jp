# -*- coding: utf-8 -*-

# http://www.aozora.gr.jp/cards/000042/card2363.html
# 
# 図書カード: No.2363
# 
# 作品名: 茶わんの湯
# 作品名読み: ちゃわんのゆ
# 作品集名: 寺田寅彦随筆集第二巻「科学について」
# 作品集名読み: てらだとらひこずいひつしゅうだいにかん「かがくについて」
# 著者名: 寺田 寅彦
# 
# http://www.aozora.gr.jp/cards/000042/files/2363_ruby_4700.zip
# chawanno_yu.txt

require File.absolute_path('../../fetcher.rb', __FILE__)

class Aozora2363 < AozoraFetcher
  URL    = 'http://www.aozora.gr.jp/cards/000042/files/2363_ruby_4700.zip'
  SOURCE = 'chawanno_yu.txt'

  class << self
    def run
      super(:url => URL, :archive_name => '2363.zip', :source => SOURCE,
            :output => '2363.txt')
    end
  end
end

Aozora2363.run

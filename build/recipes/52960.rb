# -*- coding: utf-8 -*-

# http://www.aozora.gr.jp/cards/001475/card52960.html
# 
# 図書カード: No.52960
# 
# 作品名: 赤い船のお客
# 作品名読み: あかいふねのおきゃく
# 著者名: 小川 未明
# 
# http://www.aozora.gr.jp/cards/001475/files/52960_ruby_46826.zip
# akai_funeno_okyaku.txt

require File.absolute_path('../../fetcher.rb', __FILE__)

class Aozora52960 < AozoraFetcher
  URL    = 'http://www.aozora.gr.jp/cards/001475/files/52960_ruby_46826.zip'
  SOURCE = 'akai_funeno_okyaku.txt'

  class << self
    def run
      super(:url => URL, :archive_name => '52960.zip', :source => SOURCE,
            :output => '52960.txt')
    end
  end
end

Aozora52960.run

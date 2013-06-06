# -*- coding: utf-8 -*-

# http://www.aozora.gr.jp/cards/000148/card789.html
# 
# 図書カード: No.789
# 
# 作品名:     吾輩は猫である
# 作品名読み: わがはいはねこである
# 著者名:     夏目 漱石
# 
# http://www.aozora.gr.jp/cards/000148/files/789_ruby_5639.zip
# wagahaiwa_nekodearu.txt

require File.absolute_path('../../fetcher.rb', __FILE__)

class Aozora789 < AozoraFetcher
  URL    = 'http://www.aozora.gr.jp/cards/000148/files/789_ruby_5639.zip'
  SOURCE = 'wagahaiwa_nekodearu.txt'

  class << self
    def run
      super(:url => URL, :archive_name => '789.zip', :source => SOURCE,
            :output => '789.txt')
    end

    def create_manager
      manager = TextFilterManager.new
      manager << UTF8Converter.new
      manager << AozoraTrimHeader.new
      manager << AozoraTrimTrailer.new
      manager << NakamidashiTrimmer.new
      manager << BlankTrimmer.new
      manager << AozoraTrimmer.new
      manager << AccentTrimmer.new
      manager << FileOutput.new(@output_file)
      manager.setup

      return manager
    end
  end

  class NakamidashiTrimmer
    include TextFilter

    def input(line)
      if line !~ %r{^ \s* ［＃ .*? 中見出し］ \s* $}xmo
        puts line
      end
    end
  end

  class AccentTrimmer
    include TextFilter

    def input(line)
      line.gsub! %r{〔 (.*?) 〕}, ' \\1 '

      puts line
    end
  end
end

Aozora789.run

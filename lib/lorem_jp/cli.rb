# -*- coding: utf-8 -*-
require 'lorem_jp'
require 'optparse'

class LoremJP
  class CLI
    def self.main
      dict  = nil
      chain = nil

      opt = OptionParser.new

      opt.on('-f DICT',  'dictionary filename') {
        |v| dict = v
      }
      opt.on('-c CHAIN', 'chain of precedences' +
                         ' (default: set in dictionary)') {
        |v| chain = v.to_i
      }

      opt.parse! ARGV

      options = {}
      options[:dictionary] = dict   if dict
      options[:chain]      = chain  if chain

      puts LoremJP.sentence(options)
    end
  end
end

if __FILE__ == $0
  LoremJP::CLI.main
end

# -*- coding: utf-8 -*-
require 'minitest/spec'
require 'minitest/autorun'
require 'lorem_jp'
require 'stringio'

describe LoremJP do
  it 'generate sentence with 1 chain' do
    dict = StringIO.new(<<-'END_DICT')
1

A
B
C
D

0=1
1=2
2=3,4
3=-1
4=-1
    END_DICT

    lorem = LoremJP.new( :dictionary => dict, :lazy => false )

    5.times do
      lorem.sentence.must_match %r{^ A B (C | D) $}xmo
    end
  end

  it 'generate sentence with 2 chain' do
    dict = StringIO.new(<<-'END_DICT')
2

A
B
C
D

0
 0=1
 1=2,4
1
 2=3,4
 4=2,3
2
 3=-1
 4=-1
4
 2=-1
 3=-1
    END_DICT

    lorem = LoremJP.new( :dictionary => dict, :lazy => false )

    5.times do
      lorem.sentence.must_match %r{^ A (B (C|D) | D (B|C) ) $}xmo
    end
  end
end

# -*- coding: utf-8 -*-

class LoremJP
  VERSION = '0.0.1'

  DICTIONARY_DIR     = File.absolute_path('../../data', __FILE__)
  DEFAULT_DICTIONARY = File.join(DICTIONARY_DIR, 'dict.txt')

  class << self
    def sentence(options = {})
      return singleton_for_dict(options[:dictionary]).sentence(options)
    end

    private

    def singleton_for_dict(dictionary)
      @singleton ||= {}

      @singleton[dictionary] ||= self.new(:dictionary => dictionary,
                                          :lazy => true)

      return @singleton[dictionary]
    end
  end

  def initialize(options = {})
    @dictionary = dictionary_file(options[:dictionary])
    @chain      = options[:chain] || 1

    lazy = options[:lazy] || false

    @dict   = []
    @tree   = {}
    @loaded = false

    if ! lazy
      load_dict_from_file(@dictionary)
    end
  end

  def sentence(options = {})
    unless @loaded
      load_dict_from_file(@dictionary)
    end

    chain = options[:chain] || @chain

    unless chain > 0
      raise ArgumentError,
            "invalid chain option value (#{chain})."
    end
    unless chain <= @chain
      raise ArgumentError,
            "chain option value (#{chain}) exceeds dict's chain (#{@chain})"
    end

    tokens = []
    stack = [ 0 ] * chain

    loop do
      cands = lookup_candidates(stack)
      cand = cands[rand(cands.length)]
      break if cand < 0   # EOS

      tokens << @dict[cand]

      stack.shift
      stack << cand
    end

    return tokens.join('')
  end

  private

  def dictionary_file(filename)
    pathname = nil
    if filename
      [ nil, DICTIONARY_DIR ].each do |basedir|
        begin
          pathname = File.realpath(filename, basedir)
          break
        rescue Errno::ENOENT
        end
      end
    else
      filename = DEFAULT_DICTIONARY
      pathname = File.realpath(filename)
    end

    unless pathname
      raise ArgumentError,
            "dictionary file (#{filename}) not found"
    end

    return pathname
  end

  def load_dict_from_file(filename)
    open(filename, 'r:utf-8:utf-8') { |handle|
      load_dict_from_stream(handle)
    }
  end

  def load_dict_from_stream(stream)
    step = 0

    stack = []

    stream.each do |line|
      line.chomp!

      case step
      when 0
        # chain
        @chain = line.to_i
        step = 1
      when 1
        # first word dict entry is '' (empty)
        @dict << line
        step = 2
      when 2
        # word dictionary
        if line == ''   # separator
          step = 3
        else
          @dict << line
        end
      else
        # probability tree

        # turn heading spaces into preceding stack
        new_stack = []
        tokens = line.split(%r{[ ]}xmo)
        while tokens.length > 0
          if tokens[0].empty?
            tokens.shift    # trim first (empty) token
            new_stack << stack.shift
          else
            new_stack << tokens.join('')
            tokens = []
          end
        end
        stack = new_stack

        insert_tree_node(stack)
      end
    end

    @loaded = true
  end

  def insert_tree_node(stack)
    stack = stack.dup

    node = @tree
    while stack.length > 0
      token = stack.shift

      if token =~ %r{=}xmo
        child, cands = token.split(%r{=}, 2)

        word_id = child.to_i

        node[word_id] = cands.split(%r{, \s*}xmo).map { |token| token.to_i }

        break
      else
        word_id = token.to_i
        node[word_id] ||= {}
        node = node[word_id]
      end
    end
  end

  def lookup_candidates(stack)
    stack = stack.dup

    node = @tree
    while stack.length > 0
      break if node.nil?
      break if node.is_a?(Array)

      word = stack.shift
      node = node[word]
    end

    if node.is_a?(Hash)
      return node.keys
    elsif node.is_a?(Array)
      return node
    else
      return [ -1 ]   # EOS
    end
  end
end

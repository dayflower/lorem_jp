# -*- coding: utf-8 -*-
require 'open3'
require 'optparse'

class MarkovCalculator
  def initialize(options = {})
    @chain       = options[:chain] || 1
    @ignore_type = options[:ignore_type]

    # word dictionary
    @dict = { '' => { :id => 0, :word => '', :next => [] } }
    @word_id = 1

    # probability (candidates)
    @tree = {}

    clear_stack
  end

  def input_line(line)
    line = line.chomp
    return if line == 'EOS'

    word, type = line.split(%r{\s+})

    if word == '」'
      sentence_is_terminated
      return
    end

    return if word == '「' || word == '」'

    if @ignore_type
      line = word
    end

    # register word to dictionary
    if @dict.has_key?(line)
      id = @dict[line][:id]
    else
      id = @word_id
      @word_id += 1
      @dict[line] = { :id => id, :word => word }
    end

    # add to candidates
    add_word_to_candidate id

    @stack.shift
    @stack << id

    # termination
    if %w[ 。 ？ ！ ].include?(word)
      sentence_is_terminated
    end

    return
  end

  def input(lines)
    lines.each do |line|
      input_line(line.chomp)
    end
  end

  def output_dictionary(handle)
    # chains
    handle.puts @chain.to_s

    # word dictionary
    output_words handle

    # separator
    handle.puts

    # probabilities
    output_tree handle
  end

  def output_words(handle)
    @dict.values.sort_by { |item| item[:id] }.each do |item|
      handle.puts item[:word]
    end
  end

  def output_tree(handle)
    output_tree_node(handle, @tree, 0)
  end

  private

  def output_tree_node(handle, node, depth)
    node.keys.sort.each do |key|
      child = node[key]

      handle.write %q{ } * depth
      handle.write key

      if child.has_key?(:cands)
        handle.write "="

        cands = child[:cands].sort
        first = cands[0]
        if cands.all? { |v| v == first }
          cands = [ first ]
        end

        handle.puts cands.join(",")
      else
        handle.write "\n"

        output_tree_node(handle, child, depth + 1)
      end
    end
  end

  def sentence_is_terminated
    while @stack[0] != -1
      add_word_to_candidate -1   # EOS

      @stack.shift
      @stack << -1
    end

    clear_stack
  end

  def add_word_to_candidate(word_id)
    node = @tree
    s = @stack.dup
    while s.length > 0
      wid = s.shift
      node[wid] ||= {}
      node = node[wid]
    end

    node[:cands] ||= []
    node[:cands] << word_id
  end

  def clear_stack
    @stack = [ 0 ] * @chain
  end

  class CLI
    def self.main
      chain       = 1
      ignore_type = false

      opt = OptionParser.new

      opt.on('-c CHAIN', 'chain of precedences (default: 1)') {
        |v| chain = v.to_i
      }
      opt.on('-n',       'ignore a part of speech') {
        |v| ignore_type = v
      }

      opt.parse! ARGV

      calculator = MarkovCalculator.new(:chain => chain,
                                        :ignore_type => ignore_type)

      Open3.popen3('mecab -O simple') { |stdin, stdout, stderr, wait_thr|
        Thread.fork {
          ARGF.set_encoding 'utf-8:utf-8'
          ARGF.each do |line|
            stdin.puts line.gsub(%r{(?: ^ [\s　]+ | [\s　]+ $ )}xmo, '')
          end
          stdin.close
        }

        calculator.input(stdout)
      }

      calculator.output_dictionary(STDOUT)
    end
  end
end

if __FILE__ == $0
  MarkovCalculator::CLI.main
end

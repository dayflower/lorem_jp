# -*- coding: utf-8 -*-

require 'fileutils'
require 'stringio'
require 'open-uri'

module TextFilter
  attr_accessor :next_filter

  def input(line)
    raise 'must be overriden'
  end

  def finish
    if @next_filter
      @next_filter.finish
    end
  end

  private

  def puts(line)
    @next_filter.input(line)
  end
end

class ResultCatcher < Array
  include TextFilter

  def input(line)
    self << line
  end
end

class FileOutput
  include TextFilter

  def initialize(filename)
    @handle = open filename, 'w:utf-8'
  end

  def input(line)
    @handle.write line
  end

  def finish
    @handle.close

    if @next_filter
      @next_filter.finish
    end
  end
end

class TextFilterManager < Array
  def setup
    last = nil
    (self.size - 1).downto(0) do |i|
      self[i].next_filter = last
      last = self[i]
    end
  end

  def input(line)
    self.first.input line
  end

  def finish
    self.first.finish
  end
end

class UTF8Converter
  include TextFilter

  def input(line)
    puts line.encode('UTF-8')
  end
end

class BlankTrimmer
  include TextFilter

  def input(line)
    line.sub!(%r{^　+}xmo, '')

    if line !~ %r{^\s*$}xmo
      puts line
    end
  end
end

class AozoraTrimmer
  include TextFilter

  def input(line)
    puts line.gsub(%r{｜(\S+?)《.*?》}xmo, '\\1') \
             .gsub(%r{《.*?》}xmo, '') \
             .gsub(%r{［＃.*?］}xmo, '')
  end
end

class AozoraTrimHeader
  include TextFilter

  def initialize
    @state = 0
  end

  def input(line)
    case @state
    when 2
      puts line
    when 0, 1
      if line =~ %r{^----------}
        @state += 1
      end
    end
  end
end

class AozoraTrimTrailer
  include TextFilter

  def initialize
    @state = 0
  end

  def input(line)
    case @state
    when 1
      # pass
    when 0
      if line =~ %r{^底本：}
        @state = 1
      else
        puts line
      end
    end
  end
end

class StandardFetcher
  class << self
    DOWNLOAD_DIR = File.absolute_path('../download/', __FILE__)

    def fetch(filename, url, options = {})
      force = options[:force]

      output_file = File.join(DOWNLOAD_DIR, filename)
      if File.exists?(output_file) && ! force
        return output_file
      end

      unless Dir.exists?(DOWNLOAD_DIR)
        FileUtils.makedirs(DOWNLOAD_DIR)
      end

      begin
        Kernel.open output_file, 'wb:ASCII-8BIT' do |file|
          Kernel.open url, 'rb' do |net|
            begin
              loop do
                buf = net.sysread(4096)
                len = file.write buf
              end
            rescue EOFError
              # pass
            end
          end
        end

      rescue
        File.unlink output_file rescue nil
        raise
      end

      return output_file
    end

    def extract(archive, target, options = { :external_encoding => 'CP932' })
      if ! File.exists?(archive)
        raise
      end

      cmdline = "unzip -xqc #{archive} #{target} 2>/dev/null"
      result  = StringIO.new

      IO.popen(cmdline, 'r', options) { |io|
        loop do
          line = io.gets
          break if line.nil?
          result.write line
        end
      }
      if $?.exitstatus !=0
        raise "#{$?}"
      end

      result.rewind

      return result
    end
  end
end

class AozoraFetcher < StandardFetcher
  class << self
    TEXT_DIR = File.absolute_path('../text/', __FILE__)

    def run(args = {})
      @output_file = File.join(TEXT_DIR, args[:output])
      if File.exists?(@output_file) && ! args[:force]
        return @output_file
      end

      archive = fetch(args[:archive_name], args[:url])

      unless Dir.exists?(TEXT_DIR)
        FileUtils.makedirs(TEXT_DIR)
      end

      manager = create_manager

      source = extract(archive, args[:source])
      source.each do |line|
        manager.input line
      end

      manager.finish

      return @output_file
    end

    def create_manager
      manager = TextFilterManager.new
      manager << UTF8Converter.new
      manager << AozoraTrimHeader.new
      manager << AozoraTrimTrailer.new
      manager << BlankTrimmer.new
      manager << AozoraTrimmer.new
      manager << FileOutput.new(@output_file)
      manager.setup

      return manager
    end
  end
end

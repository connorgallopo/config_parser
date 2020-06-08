require 'rails'
class Configuration
  def initialize(path)
    self.file = Pathname.new(path)
    self.configuration = load
  end

  delegate_missing_to :configuration

  private

  attr_accessor :configuration, :file, :path

  def load
    file.each_line.each_with_object({}) do |line, config|
      config.merge!(parse_line(line))
    end
  end

  def parse_line(line)
    CommentLine.call(line) ||
    NumberLine.call(line)  ||
    BooleanLine.call(line) ||
    StringLine.call(line)  ||
    BadLine.call(line)
  end

  ConfigLineMatcher = /^\s*(?<name>\w+)\s*=\s*(?<value>.+)$/

  CommentLine = ->(line) do
    return {} if line.match(/\A\s*#.*\z/)
  end

  NumberLine = ->(line) do
    match = line.match(ConfigLineMatcher)
    return nil unless match

    name = match[:name]
    value = Integer(match[:value]) rescue nil
    value ||= Float(match[:value]) rescue nil

    { name => value } if value
  end

  BooleanLine = ->(line) do
    match = line.match(ConfigLineMatcher)
    return nil unless match

    name = match[:name]
    value = true if ["t", "true", "y", "yes", "on"].include?(match[:value].downcase)
    value ||= false if ["f", "false", "n", "no", "off"].include?(match[:value].downcase)

    { name => value } if value == true || value == false
  end

  StringLine = ->(line) do
    match = line.match(ConfigLineMatcher)
    return nil unless match

    { match[:name] => match[:value] }
  end

  BadLine = ->(line) do
    $stderr.puts "Unable to parse line: `#{line.inspect}`"
    {}
  end
end

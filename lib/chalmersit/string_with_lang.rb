class Chalmersit::StringWithLang

  attr_accessor :lang, :value

  def initialize(string)
    @lang, @value = string.split(';', 2)
  end

  def self.create(la, string)
    self.new("#{la};#{string}")
  end

  %w(sv en).each do |l|
    define_singleton_method "create_#{l}" do |str|
      self.create(l, str)
    end
  end

  def to_s
    @value
  end

  def original
    "#{@lang};#{@value}"
  end
end

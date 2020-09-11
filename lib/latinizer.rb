class Latinizer
  require 'chinese_pinyin'
  require 'translit'
  require 'unicode/scripts'
  require 'babosa'
  require_relative './lib/arabic.rb'
  require_relative './lib/ascii.rb'
  require_relative './lib/japanese.rb'

  SUPPORTED_SCRIPTS = [
    'Arabic',
    'Cyrillic',
    'Han',
    'Japanese'
  ]

  def self.t(text, opt = nil)
    scripts = detect_non_latin_scripts(text)
    puts scripts

    if scripts.size == 0
      return opt == :ascii ? remove_non_ascii(text) : text
    elsif scripts.size > 1
      latinized = latinize_script(text, scripts.first, opt)
      return t(latinized, opt)
    end

    latinized = latinize_script(text, scripts.first, opt)
    opt == :ascii ? remove_non_ascii(latinized) : latinized
  end

  def self.latinize_script(text, script, opt = nil)
    puts text

    case script
    when 'Arabic'
      return Arabic.t(text)
    when 'Cyrillic'
      latinized = Translit.convert(text, :english)
      return opt == :ascii ? remove_diacritics(latinized) : latinized
    when 'Han'
      return  convert_to_pinyin(text, opt)
    when 'Japanese'
      return Japanese.t(text)
    end
    text
  end

  def self.convert_to_pinyin(string, opt = nil)
    result = []
    chars = string.split("")
    chars.each_with_index do |char, index|
      if char =~ /\p{Han}/
        converted_char = Pinyin.t(char, opt == :ascii ? {} : {tonemarks: true})
        result << ' '
        result << converted_char
      else
        result << char
      end

    end
    result.join('').gsub('  ', ' ')
  end

  def self.detect_non_latin_scripts(text)
    scripts = Unicode::Scripts.scripts(text) - ['Common', 'Inherited', 'Latin']
    if is_japanese?(scripts)
      scripts -= ['Han', 'Hiragana', 'Katakana']
      scripts += ['Japanese']
    end
    scripts.intersection(SUPPORTED_SCRIPTS)
  end

  def self.remove_diacritics(text)
    text.to_slug.transliterate.to_s
  end

  def self.remove_non_ascii(text)
    text.to_slug.transliterate.to_ascii.to_s
  end

  def self.has_non_latin?(text)
    scripts = Unicode::Scripts.scripts(text) - ['Common', 'Inherited', 'Latin']
    scripts.size > 0 ? true : false
  end

  def self.is_japanese?(scripts)
    scripts.include?('Hiragana') || scripts.include?('Katakana')
  end
end
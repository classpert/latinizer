class Latinizer
  require 'arabic'
  require 'chinese_pinyin'
  require 'mecab_standalone'
  require 'romaji'
  require 'sanscript'
  require 'translit'
  require 'unicode/scripts'
  require 'babosa'

=begin

Latinizer.t('مكة المكرمة')
Latinizer.t('Влади́мир')

Latinizer.t('संस्कृतम्')
Latinizer.t('മലയാളം')
Latinizer.t('ਗੁਰਮੁਖੀ')
Latinizer.t('ગુજરાતી')
Latinizer.t('తెలుగు')

Latinizer.t('生於魯國陬邑')
Latinizer.t('日本語わかりません')

Latinizer.t('我々宇宙人は地球を侵略しに来ました')
=end

  def self.t(text, opt = nil)
    scripts = Unicode::Scripts.scripts(text) - ['Common', 'Inherited', 'Latin']
    indic_options = :iast
    pinyin_options = {tonemarks: true}

    if opt == :ascii
      indic_options = :itrans
      pinyin_options = {}
    end

    if scripts.size == 1
      case scripts.first
      when 'Arabic'
        return Arabic.t(text)
      when 'Cyrillic'
        latinized = Translit.convert(text, :english)
        return opt == :ascii ? latinized.to_slug.to_ascii.to_s : latinized
      when 'Devanagari'
        return Sanscript.transliterate(text, :devanagari, indic_options)
      when 'Malayalam'
        return Sanscript.transliterate(text, :malayalam, indic_options)
      when 'Tamil'
        return Sanscript.transliterate(text, :tamil, indic_options)
      when 'Telugu'
        return Sanscript.transliterate(text, :telugu, indic_options)
      when 'Gurmukhi'
        return Sanscript.transliterate(text, :gurmukhi, indic_options)
      when 'Gujarati'
        return Sanscript.transliterate(text, :gujarati, indic_options)
      when 'Han'
        return Pinyin.t(text, pinyin_options)
      end
    end

    if is_japanese?(scripts)
      return romanize_japanese(text)
    end

    text
  end

  def self.is_japanese?(scripts) #fix only kana text
    (scripts.include?('Han') && (scripts.include?('Hiragana') || scripts.include?('Katakana'))) ||
    (scripts.include?('Hiragana') || scripts.include?('Katakana'))
  end

  def self.romanize_japanese(text)
    Romaji.kana2romaji(parse_japanese(text).map{|k| k[-1]}.join(' '))
  end

  def self.parse_japanese(text)
    mecab_parsed = MecabStandalone.parse(text)
      .split("\n")
      .map{|k| k.split("\t")}.tap(&:pop)
      .map{|k| [k[0]].concat(k[1].split(','))}
      .map{|k| [k[0], k[1], k[-2]]}
    tokenized_kana = []
    mecab_parsed.each do |token|
      if token[1] == "助動詞"
        tokenized_kana[-1][0] +=  token[0]
        tokenized_kana[-1][-1] += token[-1]
      elsif token[-1] == '*'
        tokenized_kana << [token[0], token[1], token[0]]
      else
        tokenized_kana << token
      end
    end
    tokenized_kana
  end
end
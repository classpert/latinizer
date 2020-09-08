class Latinizer
  require 'chinese_pinyin'
  require 'mecab_standalone'
  require 'romaji'
  require 'sanscript'
  require 'translit'
  require 'unicode/scripts'
  require 'babosa'

  def self.t(text, opt = nil)
    scripts = Unicode::Scripts.scripts(text) - ['Common', 'Inherited', 'Latin']
    indic_options = :iast
    pinyin_options = {tonemarks: true}

    if opt == :ascii
      indic_options = :itrans
      pinyin_options = {}
    elsif opt == :ja
      return romanize_japanese(text)
    end

    if scripts.size == 1
      case scripts.first
      when 'Arabic'
        return romanize_arabic(text)
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
    Romaji.kana2romaji(parse_japanese(text)
      .map{|k| k[-1]}
      .join(' ')
      .gsub('ー','')
      .gsub(' 。','.')
      .gsub(' ・','-')
      .gsub(' 、',',')
    )
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

  def self.romanize_arabic(text)
    text
    .gsub('،',',')
    .gsub('؛',';')
    .gsub('؟','?')
    .gsub('ء',"'")
    .gsub('آ','a')
    .gsub('أ','a')
    .gsub('ؤ','w')
    .gsub('إ','i')
    .gsub('ئ','ye')
    .gsub('ا','a')
    .gsub('ب','b')
    .gsub('ة','a')
    .gsub('ت','t')
    .gsub('ث','th')
    .gsub('ج','j')
    .gsub('ح','h')
    .gsub('خ','kh')
    .gsub('د','d')
    .gsub('ذ','th')
    .gsub('ر','r')
    .gsub('ز','z')
    .gsub('س','s')
    .gsub('ش','sh')
    .gsub('ص','s')
    .gsub('ض','d')
    .gsub('ط','t')
    .gsub('ظ','z')
    .gsub('ع',"'")
    .gsub('غ','gh')
    .gsub('ـ','-')
    .gsub('ف','f')
    .gsub('ق','q')
    .gsub('ك','k')
    .gsub('ل','l')
    .gsub('م','m')
    .gsub('ن','n')
    .gsub('ه','h')
    .gsub('و','w')
    .gsub('ى','a')
    .gsub('ي','y')
    .gsub('َ','a')
    .gsub('ُ','u')
    .gsub('ِ','i')
    .gsub('ْ','')
    .gsub('ٔ',"'")
    .gsub('ٕ',"'")
    .gsub('٠','0')
    .gsub('١','1')
    .gsub('٢','2')
    .gsub('٣','3')
    .gsub('٤','4')
    .gsub('٥','5')
    .gsub('٦','6')
    .gsub('٧','7')
    .gsub('٨','8')
    .gsub('٩','9')
    .gsub('٪','%')
    .gsub('٫',',')
    .gsub('٬',',')
    .gsub('ٮ','b')
    .gsub('ٯ','q')
    .gsub('ٰ','a')
    .gsub('ٱ','a')
    .gsub('ٲ','a')
    .gsub('ٳ','a')
    .gsub('ٷ','u')
    .gsub('ٹ','tt')
    .gsub('ٺ','tt')
    .gsub('ٻ','b')
    .gsub('ټ','t')
    .gsub('ٽ','t')
    .gsub('پ','p')
    .gsub('ٿ','t')
    .gsub('ڀ','b')
    .gsub('ځ','h')
    .gsub('ڂ','h')
    .gsub('ڃ','ny')
    .gsub('ڄ','dy')
    .gsub('څ','h')
    .gsub('چ','tch')
    .gsub('ڇ','tch')
    .gsub('ڈ','dd')
    .gsub('ډ','d')
    .gsub('ڊ','d')
    .gsub('ڋ','d')
    .gsub('ڌ','d')
    .gsub('ڍ','dd')
    .gsub('ڎ','d')
    .gsub('ڏ','d')
    .gsub('ڐ','d')
    .gsub('ڑ','rr')
    .gsub('ڒ','r')
    .gsub('ړ','r')
    .gsub('ڔ','r')
    .gsub('ڕ','r')
    .gsub('ږ','r')
    .gsub('ڗ','r')
    .gsub('ژ','j')
    .gsub('ڙ','r')
    .gsub('ښ','s')
    .gsub('ڛ','s')
    .gsub('ڜ','s')
    .gsub('ڝ','s')
    .gsub('ڞ','s')
    .gsub('ڟ','t')
    .gsub('ڠ','n')
    .gsub('ڡ','f')
    .gsub('ڢ','f')
    .gsub('ڣ','f')
    .gsub('ڤ','v')
    .gsub('ڥ','f')
    .gsub('ڦ','p')
    .gsub('ڧ','q')
    .gsub('ڨ','q')
    .gsub('ک','k')
    .gsub('ڪ','k')
    .gsub('ګ','k')
    .gsub('ڬ','k')
    .gsub('ڭ','ng')
    .gsub('ڮ','k')
    .gsub('گ','g')
    .gsub('ڰ','g')
    .gsub('ڱ','ng')
    .gsub('ڲ','g')
    .gsub('ڳ','g')
    .gsub('ڴ','g')
    .gsub('ڵ','l')
    .gsub('ڶ','l')
    .gsub('ڷ','l')
    .gsub('ڸ','l')
    .gsub('ڹ','n')
    .gsub('ں','n')
    .gsub('ڻ','rn')
    .gsub('ڼ','n')
    .gsub('ڽ','n')
    .gsub('ھ','h')
    .gsub('ڿ','tch')
    .gsub('ۀ','h')
    .gsub('ہ','h')
    .gsub('ۂ','h')
    .gsub('ۃ','a')
    .gsub('ۄ','w')
    .gsub('ۅ','oe')
    .gsub('ۆ','oe')
    .gsub('ۇ','u')
    .gsub('ۈ','yu')
    .gsub('ۉ','yu')
    .gsub('ۊ','w')
    .gsub('ۋ','v')
    .gsub('ی','y')
    .gsub('ۍ','y')
    .gsub('ێ','y')
    .gsub('ۏ','w')
    .gsub('ې','e')
    .gsub('ۑ','y')
    .gsub('ے','y')
    .gsub('ۓ','y')
    .gsub('۔','.')
    .gsub('ە','ae')
    .gsub('ۮ','d')
    .gsub('ۯ','r')
    .gsub('۰','0')
    .gsub('۱','1')
    .gsub('۲','2')
    .gsub('۳','3')
    .gsub('۴','4')
    .gsub('۵','5')
    .gsub('۶','6')
    .gsub('۷','7')
    .gsub('۸','8')
    .gsub('۹','9')
    .gsub('ۺ','sh')
    .gsub('ۻ','d')
    .gsub('ۼ','gh')
    .gsub('۽','&')
    .gsub('ﷲ','Allah')
    .gsub('و','w ')
    .gsub('ء',"'")
    .gsub('ٔ',"'")
    .gsub('ٕ',"'")
    .gsub('ع',"'")
    .gsub('آ','a')
    .gsub('ٓا','a')
    .gsub('إ','i')
    .gsub('ٱ','a')
    .gsub('ة','a')
    .gsub('ۃ','a')
    .gsub('ي','y')
    .gsub('ى','a')
    .gsub('ﻯ','a')
    .gsub('ﻰ','a')
    .gsub('ﯨ','a')
    .gsub('ﯩ','a')
    .gsub('ٰ','a ')
    .gsub('ـ','')
    .gsub('َ','a')
    .gsub('ُ','u')
    .gsub('ِ','i')
    .gsub('ْ','')
    .gsub('ۡ','')
    .gsub('اً','an')
    .gsub('ً','')
    .gsub('ٌ','')
    .gsub('ٍ','')
    .gsub('ّ','')
    .gsub('ڃ','ny')
    .gsub('ڄ','dy')
    .gsub('۾','men')
    .gsub('ؑ','alayhe wasallam')
    .gsub('ﷴ','Mohammad')
    .gsub('ﷸ','wasallam')
    .gsub('ﷺ','sallallahou alayhe wasallam')
  end
end
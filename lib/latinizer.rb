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
    .gsub('،',',') # ARABIC COMMA
    .gsub('؛',';') # ARABIC SEMICOLON
    .gsub('؟','?') # ARABIC QUESTION MARK
    .gsub('ء',"'") # ARABIC LETTER HAMZA
    .gsub('آ','a') # ARABIC LETTER ALEF WITH MADDA ABOVE
    .gsub('أ','a') # ARABIC LETTER ALEF WITH HAMZA ABOVE
    .gsub('ؤ','w') # ARABIC LETTER WAW WITH HAMZA ABOVE
    .gsub('إ','i') # ARABIC LETTER ALEF WITH HAMZA BELOW
    .gsub('ئ','ye') # ARABIC LETTER YEH WITH HAMZA ABOVE
    .gsub('ا','a') # ARABIC LETTER ALEF
    .gsub('ب','b') # ARABIC LETTER BEH
    .gsub('ة','a') # ARABIC LETTER TEH MARBUTA
    .gsub('ت','t') # ARABIC LETTER TEH
    .gsub('ث','th') # ARABIC LETTER THEH
    .gsub('ج','j') # ARABIC LETTER JEEM
    .gsub('ح','h') # ARABIC LETTER HAH
    .gsub('خ','kh') # ARABIC LETTER KHAH
    .gsub('د','d') # ARABIC LETTER DAL
    .gsub('ذ','th') # ARABIC LETTER THAL
    .gsub('ر','r') # ARABIC LETTER REH
    .gsub('ز','z') # ARABIC LETTER ZAIN
    .gsub('س','s') # ARABIC LETTER SEEN
    .gsub('ش','sh') # ARABIC LETTER SHEEN
    .gsub('ص','s') # ARABIC LETTER SAD
    .gsub('ض','d') # ARABIC LETTER DAD
    .gsub('ط','t') # ARABIC LETTER TAH
    .gsub('ظ','z') # ARABIC LETTER ZAH
    .gsub('ع',"'") # ARABIC LETTER AIN
    .gsub('غ','gh') # ARABIC LETTER GHAIN
    .gsub('ـ','-') # ARABIC TATWEEL
    .gsub('ف','f') # ARABIC LETTER FEH
    .gsub('ق','q') # ARABIC LETTER QAF
    .gsub('ك','k') # ARABIC LETTER KAF
    .gsub('ل','l') # ARABIC LETTER LAM
    .gsub('م','m') # ARABIC LETTER MEEM
    .gsub('ن','n') # ARABIC LETTER NOON
    .gsub('ه','h') # ARABIC LETTER HEH
    .gsub('و','w') # ARABIC LETTER WAW
    .gsub('ى','a') # ARABIC LETTER ALEF MAKSURA
    .gsub('ي','y') # ARABIC LETTER YEH
    .gsub('َ','a') # ARABIC FATHA
    .gsub('ُ','u') # ARABIC DAMMA
    .gsub('ِ','i') # ARABIC KASRA
    .gsub('ْ','') # ARABIC SUKUN
    .gsub('ٔ',"'") # ARABIC HAMZA ABOVE
    .gsub('ٕ',"'") # ARABIC HAMZA BELOW
    .gsub('٠','0') # ARABIC-INDIC DIGIT ZERO
    .gsub('١','1') # ARABIC-INDIC DIGIT ONE
    .gsub('٢','2') # ARABIC-INDIC DIGIT TWO
    .gsub('٣','3') # ARABIC-INDIC DIGIT THREE
    .gsub('٤','4') # ARABIC-INDIC DIGIT FOUR
    .gsub('٥','5') # ARABIC-INDIC DIGIT FIVE
    .gsub('٦','6') # ARABIC-INDIC DIGIT SIX
    .gsub('٧','7') # ARABIC-INDIC DIGIT SEVEN
    .gsub('٨','8') # ARABIC-INDIC DIGIT EIGHT
    .gsub('٩','9') # ARABIC-INDIC DIGIT NINE
    .gsub('٪','%') # ARABIC PERCENT SIGN
    .gsub('٫',',') # ARABIC DECIMAL SEPARATOR
    .gsub('٬',',') # ARABIC THOUSANDS SEPARATOR
    .gsub('ٮ','b') # ARABIC LETTER DOTLESS BEH
    .gsub('ٯ','q') # ARABIC LETTER DOTLESS QAF
    .gsub('ٰ','a') # ARABIC LETTER SUPERSCRIPT ALEF
    .gsub('ٱ','a') # ARABIC LETTER ALEF WASLA
    .gsub('ٲ','a') # ARABIC LETTER ALEF WITH WAVY HAMZA ABOVE
    .gsub('ٳ','a') # ARABIC LETTER ALEF WITH WAVY HAMZA BELOW
    .gsub('ٷ','u') # ARABIC LETTER U WITH HAMZA ABOVE
    .gsub('ٹ','tt') # ARABIC LETTER TTEH
    .gsub('ٺ','tt') # ARABIC LETTER TTEHEH
    .gsub('ٻ','b') # ARABIC LETTER BEEH
    .gsub('ټ','t') # ARABIC LETTER TEH WITH RING
    .gsub('ٽ','t') # ARABIC LETTER TEH WITH THREE DOTS ABOVE DOWNWARDS
    .gsub('پ','p') # ARABIC LETTER PEH
    .gsub('ٿ','t') # ARABIC LETTER TEHEH
    .gsub('ڀ','b') # ARABIC LETTER BEHEH
    .gsub('ځ','h') # ARABIC LETTER HAH WITH HAMZA ABOVE
    .gsub('ڂ','h') # ARABIC LETTER HAH WITH TWO DOTS VERTICAL ABOVE
    .gsub('ڃ','ny') # ARABIC LETTER NYEH
    .gsub('ڄ','dy') # ARABIC LETTER DYEH
    .gsub('څ','h') # ARABIC LETTER HAH WITH THREE DOTS ABOVE
    .gsub('چ','tch') # ARABIC LETTER TCHEH
    .gsub('ڇ','tch') # ARABIC LETTER TCHEHEH
    .gsub('ڈ','dd') # ARABIC LETTER DDAL
    .gsub('ډ','d') # ARABIC LETTER DAL WITH RING
    .gsub('ڊ','d') # ARABIC LETTER DAL WITH DOT BELOW
    .gsub('ڋ','d') # ARABIC LETTER DAL WITH DOT BELOW AND SMALL TAH
    .gsub('ڌ','d') # ARABIC LETTER DAHAL
    .gsub('ڍ','dd') # ARABIC LETTER DDAHAL
    .gsub('ڎ','d') # ARABIC LETTER DUL
    .gsub('ڏ','d') # ARABIC LETTER DAL WITH THREE DOTS ABOVE DOWNWARDS
    .gsub('ڐ','d') # ARABIC LETTER DAL WITH FOUR DOTS ABOVE
    .gsub('ڑ','rr') # ARABIC LETTER RREH
    .gsub('ڒ','r') # ARABIC LETTER REH WITH SMALL V
    .gsub('ړ','r') # ARABIC LETTER REH WITH RING
    .gsub('ڔ','r') # ARABIC LETTER REH WITH DOT BELOW
    .gsub('ڕ','r') # ARABIC LETTER REH WITH SMALL V BELOW
    .gsub('ږ','r') # ARABIC LETTER REH WITH DOT BELOW AND DOT ABOVE
    .gsub('ڗ','r') # ARABIC LETTER REH WITH TWO DOTS ABOVE
    .gsub('ژ','j') # ARABIC LETTER JEH
    .gsub('ڙ','r') # ARABIC LETTER REH WITH FOUR DOTS ABOVE
    .gsub('ښ','s') # ARABIC LETTER SEEN WITH DOT BELOW AND DOT ABOVE
    .gsub('ڛ','s') # ARABIC LETTER SEEN WITH THREE DOTS BELOW
    .gsub('ڜ','s') # ARABIC LETTER SEEN WITH THREE DOTS BELOW AND THREE DOTS ABOVE
    .gsub('ڝ','s') # ARABIC LETTER SAD WITH TWO DOTS BELOW
    .gsub('ڞ','s') # ARABIC LETTER SAD WITH THREE DOTS ABOVE
    .gsub('ڟ','t') # ARABIC LETTER TAH WITH THREE DOTS ABOVE
    .gsub('ڠ','n') # ARABIC LETTER AIN WITH THREE DOTS ABOVE
    .gsub('ڡ','f') # ARABIC LETTER DOTLESS FEH
    .gsub('ڢ','f') # ARABIC LETTER FEH WITH DOT MOVED BELOW
    .gsub('ڣ','f') # ARABIC LETTER FEH WITH DOT BELOW
    .gsub('ڤ','v') # ARABIC LETTER VEH
    .gsub('ڥ','f') # ARABIC LETTER FEH WITH THREE DOTS BELOW
    .gsub('ڦ','p') # ARABIC LETTER PEHEH
    .gsub('ڧ','q') # ARABIC LETTER QAF WITH DOT ABOVE
    .gsub('ڨ','q') # ARABIC LETTER QAF WITH THREE DOTS ABOVE
    .gsub('ک','k') # ARABIC LETTER KEHEH
    .gsub('ڪ','k') # ARABIC LETTER SWASH KAF
    .gsub('ګ','k') # ARABIC LETTER KAF WITH RING
    .gsub('ڬ','k') # ARABIC LETTER KAF WITH DOT ABOVE
    .gsub('ڭ','ng') # ARABIC LETTER NG
    .gsub('ڮ','k') # ARABIC LETTER KAF WITH THREE DOTS BELOW
    .gsub('گ','g') # ARABIC LETTER GAF
    .gsub('ڰ','g') # ARABIC LETTER GAF WITH RING
    .gsub('ڱ','ng') # ARABIC LETTER NGOEH
    .gsub('ڲ','g') # ARABIC LETTER GAF WITH TWO DOTS BELOW
    .gsub('ڳ','g') # ARABIC LETTER GUEH
    .gsub('ڴ','g') # ARABIC LETTER GAF WITH THREE DOTS ABOVE
    .gsub('ڵ','l') # ARABIC LETTER LAM WITH SMALL V
    .gsub('ڶ','l') # ARABIC LETTER LAM WITH DOT ABOVE
    .gsub('ڷ','l') # ARABIC LETTER LAM WITH THREE DOTS ABOVE
    .gsub('ڸ','l') # ARABIC LETTER LAM WITH THREE DOTS BELOW
    .gsub('ڹ','n') # ARABIC LETTER NOON WITH DOT BELOW
    .gsub('ں','n') # ARABIC LETTER NOON GHUNNA
    .gsub('ڻ','rn') # ARABIC LETTER RNOON
    .gsub('ڼ','n') # ARABIC LETTER NOON WITH RING
    .gsub('ڽ','n') # ARABIC LETTER NOON WITH THREE DOTS ABOVE
    .gsub('ھ','h') # ARABIC LETTER HEH DOACHASHMEE
    .gsub('ڿ','tch') # ARABIC LETTER TCHEH WITH DOT ABOVE
    .gsub('ۀ','h') # ARABIC LETTER HEH WITH YEH ABOVE
    .gsub('ہ','h') # ARABIC LETTER HEH GOAL
    .gsub('ۂ','h') # ARABIC LETTER HEH GOAL WITH HAMZA ABOVE
    .gsub('ۃ','a') # ARABIC LETTER TEH MARBUTA GOAL
    .gsub('ۄ','w') # ARABIC LETTER WAW WITH RING
    .gsub('ۅ','oe') # ARABIC LETTER KIRGHIZ OE
    .gsub('ۆ','oe') # ARABIC LETTER OE
    .gsub('ۇ','u') # ARABIC LETTER U
    .gsub('ۈ','yu') # ARABIC LETTER YU
    .gsub('ۉ','yu') # ARABIC LETTER KIRGHIZ YU
    .gsub('ۊ','w') # ARABIC LETTER WAW WITH TWO DOTS ABOVE
    .gsub('ۋ','v') # ARABIC LETTER VE
    .gsub('ی','y') # ARABIC LETTER FARSI YEH
    .gsub('ۍ','y') # ARABIC LETTER YEH WITH TAIL
    .gsub('ێ','y') # ARABIC LETTER YEH WITH SMALL V
    .gsub('ۏ','w') # ARABIC LETTER WAW WITH DOT ABOVE
    .gsub('ې','e') # ARABIC LETTER E
    .gsub('ۑ','y') # ARABIC LETTER YEH WITH THREE DOTS BELOW
    .gsub('ے','y') # ARABIC LETTER YEH BARREE
    .gsub('ۓ','y') # ARABIC LETTER YEH BARREE WITH HAMZA ABOVE
    .gsub('۔','.') # ARABIC FULL STOP
    .gsub('ە','ae') # ARABIC LETTER AE
    .gsub('ۮ','d') # ARABIC LETTER DAL WITH INVERTED V
    .gsub('ۯ','r') # ARABIC LETTER REH WITH INVERTED V
    .gsub('۰','0') # EXTENDED ARABIC-INDIC DIGIT ZERO
    .gsub('۱','1') # EXTENDED ARABIC-INDIC DIGIT ONE
    .gsub('۲','2') # EXTENDED ARABIC-INDIC DIGIT TWO
    .gsub('۳','3') # EXTENDED ARABIC-INDIC DIGIT THREE
    .gsub('۴','4') # EXTENDED ARABIC-INDIC DIGIT FOUR
    .gsub('۵','5') # EXTENDED ARABIC-INDIC DIGIT FIVE
    .gsub('۶','6') # EXTENDED ARABIC-INDIC DIGIT SIX
    .gsub('۷','7') # EXTENDED ARABIC-INDIC DIGIT SEVEN
    .gsub('۸','8') # EXTENDED ARABIC-INDIC DIGIT EIGHT
    .gsub('۹','9') # EXTENDED ARABIC-INDIC DIGIT NINE
    .gsub('ۺ','sh') # ARABIC LETTER SHEEN WITH DOT BELOW
    .gsub('ۻ','d') # ARABIC LETTER DAD WITH DOT BELOW
    .gsub('ۼ','gh') # ARABIC LETTER GHAIN WITH DOT BELOW
    .gsub('۽','&') # ARABIC SIGN SINDHI AMPERSAND
    .gsub('ﷲ','Allah') # ARABIC LIGATURE ALLAH ISOLATED FORM
    .gsub('و','w') # Arabic letter waw
    .gsub('ء',"'") # hamza
    .gsub('ٔ',"'") # hamza above
    .gsub('ٕ',"'") # hamza below
    .gsub('ع',"'") # ain
    .gsub('آ','a') # alef madda
    .gsub('إ','i') # alef with hamza below
    .gsub('ٱ','a') # alef wasla
    .gsub('ة','a') # teh marbuta
    .gsub('ۃ','a') # teh marbuta goal
    .gsub('ي','y') # Arabic yeh
    .gsub('ى','a') # alef maksura
    .gsub('ﻯ','a') # alef maksura isolated form
    .gsub('ﻰ','a') # alef maksura final form
    .gsub('ﯨ','a') # Uighur Kazach Kirghiz alef maksura initial form
    .gsub('ﯩ','a') # Uighur Kazach Kirghiz alef maksura medial form
    .gsub('ٰ','a ') # Arabic letter superscript alef
    .gsub('ـ','') # tatweel (filler)
    .gsub('َ','a') # fatha ("-a")
    .gsub('ُ','u') # damma ("-u")
    .gsub('ِ','i') # kasra ("-i")
    .gsub('ْ','') # sukun (no vowel)
    .gsub('ۡ','') # comment small high dotless head of khah; like sukun (no vowel); used in Kashmiri, Assamese
    .gsub('اً','an') # alef + fathatan
    .gsub('ً','') # fathatan ("-an")
    .gsub('ٌ','') # dammatan ("-un")
    .gsub('ٍ','') # kasratan ("-in")
    .gsub('ّ','') # shadda (consonant doubler)
    .gsub('ڃ','ny') # Arabic letter nyeh U+0683 (used in Sindhi (snd))
    .gsub('ڄ','dy') # Arabic letter dyeh U+0684 (used in Sindhi (snd))
    .gsub('۾','men') # Sindhi postposition men
    .gsub('ؑ','alayhe wasallam') # "upon him be peace"
    .gsub('ﷴ','Mohammad') # "Mohammad"
    .gsub('ﷸ','wasallam') # "and peace"
    .gsub('ﷺ','sallallahou alayhe wasallam') # "prayer of God be upon him and his family and peace"
  end
end
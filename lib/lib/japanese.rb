class Japanese
  require 'mecab_standalone'
  require 'romaji'

  JAPANESE_PONCTUATION = {
    '　' => ' ',
    '、' => ',',
    '。' => '.',
    '：' => ':',
    '！' => '!',
    '？' => '?',
    '〜' => '~',
    '…' => '...',
    '‥' => '..',
    '「 ' => ' \'',
    '」' => '\'',
    '『 ' => ' "',
    '』' => '"',
    '〝 ' => ' "',
    '〟' => '"',
    '（ ' => ' (',
    '）' => ')',
    '【 ' => ' [',
    '】' => ']',
    '｛ ' => ' {',
    '｝' => '}',
}.freeze

  def self.t(text)
    latin = text.dup
    parsed = parse(text)
    parsed.each do |token|
      if token[-1]=~ /\p{Katakana}/
        latin.sub!(token[0], ' ' + Romaji.kana2romaji(token[-1]) )
      end
    end
    JAPANESE_PONCTUATION.each { |k,v| latin.gsub!(k, v)}
    latin
  end

  def self.parse(text)
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
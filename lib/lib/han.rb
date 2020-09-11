class Han
  require 'chinese_pinyin'

  def self.t(text, opt = nil)
    latin = []
    chars = text.split("")
    chars.each_with_index do |char, index|
      if char =~ /\p{Han}/
        converted_char = Pinyin.t(char, opt == :ascii ? {} : {tonemarks: true})
        latin << ' '
        latin << converted_char
      else
        latin << char
      end
    end
    latin.join('').gsub('  ', ' ')
  end
end
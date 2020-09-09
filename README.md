# Latinizer

A simple general latinization / romanization / transliteration gem.
Basically a wrapper for more specific gems. It uses unicode/scripts to detect the script present in the string and then calls a more specific romanization gem.

The romanization of the following  scripts is currently supported:
- Chinese Characters, with the gem [ChinesePinyin](https://github.com/flyerhzm/chinese_pinyin)
- Arabic, with a conversion table based on [URoman](https://github.com/isi-nlp/uroman)
- Cyrillic, with the gem [Translit](https://github.com/tjbladez/translit)
- Japanese, with the gems [Romaji](https://github.com/makimoto/romaji) and [Mecab Standalone](https://github.com/wyugue/mecab_standalone) (a Ruby wrapper for Mecab). Mecab is also used to ensure correct kanji readings and tokenization.

## Installation
```
gem install latinizer
```

Due to Mecab Standalone, this gem might not work in all environments.


## Usage
```
require 'latinizer'

Latinizer.t('漢語，又稱中文、唐話、華語为整个汉语族，')
 => "hàn yǔ  yòu chēng zhōng wén  táng huà  huá yǔ wèi zhěng gè hàn yǔ zú"

Latinizer.t('اللُّغَة العَرَبِيّة هي أكثر اللغات السامية تحدثاً')
 => "allughaa al'arabiya hy akthr allghat alsamya thdtha"

Latinizer.t('平仮名は、日本語の表記に用いられる音節文字')
 => "hiragana ha, nihongo no hyouki ni mochii rareru onsetsu moji"

Latinizer.t('Ру́сский язы́к один из восточнославянских языков, национальный язык русского народа.')
 => "Rússkij qzýk odin iz wostochnoslawqnskih qzykow, nacional'nyj qzyk russkogo naroda."
```

Use option `:ascii` for ascii only output. This will remove tones in Chinese:
```
Latinizer.t('漢語，又稱中文、唐話、華語为整个汉语族，', :ascii)
 => "han yu  you cheng zhong wen  tang hua  hua yu wei zheng ge han yu zu"
```

Use option `:ja` to force Japanese romanization on kanji-only strings

```
Latinizer.t('日本語')
 => "rì běn yǔ"

Latinizer.t('日本語', :ja)
 => "nihongo"
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

This project uses the universal romanizer software 'uroman' written by Ulf Hermjakob, USC Information Sciences Institute (2015-2020)
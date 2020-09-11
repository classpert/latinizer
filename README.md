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
 => " hàn yǔ， yòu chēng zhōng wén、 táng huà、 huá yǔ wèi zhěng gè hàn yǔ zú，"

Latinizer.t('اللُّغَة العَرَبِيّة هي أكثر اللغات السامية تحدثاً')
 => "allughaa al'arabiya hy akthr allghat alsamya thdtha"

Latinizer.t('平仮名は、日本語の表記に用いられる音節文字')
 => "hiragana ha, nihongo no hyouki ni mochii rareru onsetsu moji"

Latinizer.t('Ру́сский язы́к один из восточнославянских языков, национальный язык русского народа.')
 => "Rússkij qzýk odin iz wostochnoslawqnskih qzykow, nacional'nyj qzyk russkogo naroda."

Latinizer.t('漢語, العَرَبِيّة, Ру́сский, Português, Español')
 => " hàn yǔ, al'arabiya, Rússkij, Português, Español"
```

Scripts that are not available are kept
```
Latinizer.t('漢語, العَرَبِيّة, Ру́сский, Português, Español, ଓଡ଼ିଆ')
 => " hàn yǔ, al'arabiya, Rússkij, Português, Español, ଓଡ଼ିଆ"
```


Use option `:ascii` for ASCII only output. This will remove all diacritics and non-latin characters:
```
Latinizer.t('漢語，又稱中文、唐話、華語为整个汉语族，', :ascii)
 => " han yu, you cheng zhong wen, tang hua, hua yu wei zheng ge han yu zu,"

Latinizer.t('漢語, العَرَبِيّة, Ру́сский, Português, Español, ଓଡ଼ିଆ', :ascii)
 => " han yu, al'arabiya, Russkij, Portugues, Espanol, "

 Latinizer.t("Türkçe ya da Türk dili, Güneydoğu Avrupa ve Batı Asya'da konuşulan, Türk dilleri dil ailesine ait sondan eklemeli bir dil.", :ascii)
 => "Turkce ya da Turk dili, Guneydogu Avrupa ve Bati Asya'da konusulan, Turk dilleri dil ailesine ait sondan eklemeli bir dil."
```

Japanese ponctuation is also ASCII-fied:
```
Latinizer.t('7世紀の後半の国際関係から生じた「日本」国号は、当時の国際的な読み（音読）で「ニッポン」（呉音）ないし「ジッポン」（漢音）と読まれたものと推測される
')
 => "7 seiki no kouhan no kokusai kankei kara shoujita 'nippon' kokugou ha, touji no kokusai tekina yomi (ondoku) de 'nippon' (goon) naishi 'jippon' (kanon) to yoma reta mono to suisoku sa reru"
```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

This project uses the universal romanizer software 'uroman' written by Ulf Hermjakob, USC Information Sciences Institute (2015-2020)
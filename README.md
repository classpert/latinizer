# Latinizer

A simple general latinization / romanization / transliteration gem.
Basically a wrapper for more specific gems. It uses unicode/scripts to detect the script present in the string and then calls a more specific romanization gem.

The romanization of the following  scripts is currently supported:
- Chinese Characters with the gem Chinese Pinyin
- Arabic, with a conversion table based on URoman
- Devanagari, Ghurmukhi, Gujarati, Malayalam, Telugu and Tamil with the gem Sanscript. Since Sanscript is optmized for Sanskrit, southern Bhramic script support may be incomplete
- Cyrillic with the gem Translit
- Japanese wit the gems Romani and Mecab Standalone (a Ruby wrapper for Mecab). Mecab is also used to ensure correct kanji readings and tokenization.

## Installation
```
gem install latinizer
```

## Usage
```
require 'latinizer'

Latinizer.t('漢語，又稱中文、唐話、華語为整个汉语族，或者其语族里的一种语言——汉语族为东亚分析语的一支家族')
 => "hàn yǔ  yòu chēng zhōng wén  táng huà  huá yǔ wèi zhěng gè hàn yǔ zú  huò zhě qí yǔ zú lǐ de yī zhǒng yǔ yán  hàn yǔ zú wèi dōng yà fēn xī yǔ de yī zhī jiā zú"

Latinizer.t('اللُّغَة العَرَبِيّة هي أكثر اللغات السامية تحدثاً')
 => "allughaa al'arabiya hy akthr allghat alsamya thdtha"

Latinizer.t('हिन्दी विश्व की एक प्रमुख भाषा है एवं भारत की राजभाषा है')
 => "hindī viśva kī eka pramukha bhāṣā hai evaṃ bhārata kī rājabhāṣā hai"

Latinizer.t('日本国、または日本は、東アジアに位置し、日本列島および南西諸島・伊豆諸島・小笠原諸島などからなる民主制国家')
 => "nippon koku 、 mataha nippon ha 、 higashiajia ni ichi shi 、 nippon rettou oyobi nanseishotou ・ izushotou ・ ogasawarashotou nado kara naru minshu sei kokka"

Latinizer.t('Старославянская (древнеболгарская) азбука: то же, что кирилли́ческий (или кири́лловский) алфави́т: один из двух (наряду с глаголицей) древних алфавитов для старославянского языка;')
 => "Staroslawqnskaq (drewnebolgarskaq) azbuka: to zhe, chto kirillícheskij (ili kiríllowskij) alfawít: odin iz dwuh (narqdu s glagolicej) drewnih alfawitow dlq staroslawqnskogo qzyka;"
```



This project uses the universal romanizer software 'uroman' written by Ulf Hermjakob, USC Information Sciences Institute (2015-2020)
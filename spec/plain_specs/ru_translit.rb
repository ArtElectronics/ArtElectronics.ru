ENV["RAILS_ENV"] ||= 'development'
require File.expand_path("../../../config/environment", __FILE__)

# I18n
#
# ё => yo
# э => e
# ю => yu
# я => ya
# ж => zh
# х => h
# й => y
# ц => ts
# ш => sh
# щ => sch
# ь => 
# ъ => '
p "I18n/Russian by Markin"
p "SRC: Ё Э Ю Я Ж Х Й Ц Ш Щ Ь Ъ"
p "REQ: yo-e-yu-ya-zh-h-y-ts-sh-sch"
p "Ё Э Ю Я Ж Х Й Ц Ш Щ Ь Ъ".to_slug_param
p "Ё Э Ю Я Ж Х Й Ц Ш Щ Ь Ъ".to_slug_param == "yo-e-yu-ya-zh-h-y-ts-sh-sch"

# YANDEX
#
# ё => e
# э => e
# ю => yu ju
# я => ya (ja)
# ж => zh
# х => kh
# й => j
# ц => ts
# ш => sh
# щ => sch
# ь => 
# ъ =>
p "I18n/Russian for Yandex"
p "SRC: Ё Э Ю Я Ж Х Й Ц Ш Щ Ь Ъ"
p "REQ: e-e-yu-ya-zh-kh-j-ts-sh-sch"
p "Ё Э Ю Я Ж Х Й Ц Ш Щ Ь Ъ".to_slug_param
p "Ё Э Ю Я Ж Х Й Ц Ш Щ Ь Ъ".to_slug_param == "e-e-yu-ya-zh-kh-j-ts-sh-sch"
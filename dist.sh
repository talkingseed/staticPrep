#!/bin/bash

# Scripts for image prep
#./export_img_srcset.sh -d employer_logo/ -h 24
#echo Done exporting employer logos
#./export_img_thumbs.sh -d memes/ -h 136
#echo Done exporting memes and their thumbs

./css_insert_fallback.pl CSS/home.css > CSS/home_dist.css
./css_insert_fallback.pl CSS/quote.css > CSS/quote_dist.css
echo Inserted fallbacks to css
npx postcss CSS/reset.css > CSS/reset_min.css
npx postcss CSS/home_dist.css > CSS/home_dist_min.css
rm CSS/home_dist.css
npx postcss CSS/quote_dist.css > CSS/quote_dist_min.css
rm CSS/quote_dist.css
echo minified css
npx swc --quiet --config-file ../.swcrc  JS/comfySlider.js > JS/comfySlider_min.js
npx swc --quiet --config-file ../.swcrc  JS/togglePrefTheme.js > JS/togglePrefTheme_min.js
echo minified js

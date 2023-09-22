#!/bin/bash
npx postcss CSS/reset.css > CSS/reset_min.css
npx postcss CSS/home.css > CSS/home_min.css
npx swc JS/comfySlider.js > JS/comfySlider_min.js
php index.php > index.html
echo Done!

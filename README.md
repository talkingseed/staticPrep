# staticPrep
Bash scripts for JS and CSS fallback generation and minification. The only tricky part on Windows is to make sure that your terminal uses UTF-8 to make sure that no unicode symbols were broken during piping (">")

perl script for inserting fallback lines for var() and calc() CSS statements (PaultT wrote it for me)
Example:

./css_insert_fallback.pl CSS/home.css > CSS/home_with_fallback.css

home.css:
```css
:root {
  --phi: 1.618;
  --phi-sqrt: 1.272;
  --base-font: 1.2187rem; 
  --font4: calc(var(--base-font)  * var(--phi-sqrt));
  --font5: var(--base-font);
  ...
  --height5: calc( var(--font5) * var(--base-xh-lnH));
  ...
}
body {
    font-family:  Verdana, Geneva, sans-serif; /*Comfortaa, Roboto, Arial, sans-serif;*/
    font-size: 1.2187rem;
    line-height: 1.7388rem;
    font-weight: 400;
    font-size: var(--font5);
    line-height: var(--height5);
    ...
}
```

home.css with fallback inserts:
```css
body {
    font-family:  Verdana, Geneva, sans-serif; 
    font-size: 1.2187rem;
    line-height: 1.7388rem;
    font-weight: 400;
    font-size: 1.2187rem;
    font-size: var(--font5);
    line-height: 1.7389rem; 
    line-height: var(--height5); 
    ...
}
```

CSSnano for minificatiom

swc for JS fallback generation and minification

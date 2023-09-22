# staticPrep
Bash scripts for JS and CSS fallback generation and minification. The only tricky part on Windows is to make sure that your terminal uses UTF-8 to make sure that no unicode symbols were broken during piping (">")

perl script for inserting fallback lines for var() and calc() CSS statements (PaultT wrote it for me)
Example:

./css_insert_fallback.pl CSS/home.css > CSS/home_with_fallback.css

CSSnano for minificatiom

swc for JS fallback generation and minification

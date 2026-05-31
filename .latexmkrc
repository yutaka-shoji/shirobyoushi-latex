# latexmk configuration for SHASE Transactions white-cover manuscript (LuaLaTeX)

$out_dir = 'out';
$aux_dir = 'out';

$pdf_mode = 4;  # use lualatex
$lualatex = 'lualatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error -halt-on-error %O %S';
$bibtex = 'upbibtex %O %B';

$max_repeat = 5;
$recorder = 1;

@default_files = ('manuscript.tex');

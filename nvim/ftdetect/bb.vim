" Quick hack to set Babashka files as Clojure filetype
" https://neovim.io/doc/user/filetype.html#ftdetect
"
" Alternative solutions welcome
"
" TODO: consider a lua solution
" TODO: contribute bb support for clojure to Neovim (vim)

au BufRead,BufNewFile *.bb		set filetype=clojure

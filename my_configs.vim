" set clipboard=unnamedplus
" setting for 'https://github.com/christoomey/vim-system-copy'
" cpiw => copy word into system clipboard
" cpi' => copy inside single quotes to system clipboard
" cvi' => paste inside single quotes from system clipboard
" cP   => copy the current line directly.
" cV   => paste the content of system clipboard to the next line.
let g:system_copy#copy_command='xclip -sel clipboard'
let g:system_copy#paste_command='xclip -sel clipboard -o'

" if remote sever, then add 'https://github.com/ojroques/vim-oscyank.git'
" setting for 'vim-oscyank'
" nmap <leader>c <Plug>OSCYankOperator
" nmap <leader>cc <leader>c_
" vmap <leader>c <Plug>OSCYankVisual
 

" setting: https://github.com/ap/vim-buftabline
let g:buftabline_numbers    = 1
let g:buftabline_indicators = 1
let g:buftabline_separators = 1

" '3,nt': jump 3rd buffer which buffer number from 1,2,3... orderly.
nmap <expr> <leader>nt '<Plug>BufTabLine.Go(' . v:count . ')'

" copy在command line中输入':command'后的结果到寄存器中,文件中...。
" https://stackoverflow.com/questions/2573021/vim-how-to-redirect-ex-command-output-into-current-buffer-or-file/2573054#2573054
" Called with a command and a redirection target
"   (see `:help redir` for info on redirection targets)
" Note that since this is executed in function context,
"   in order to target a global variable for redirection you must prefix it with `g:`.
" EG call Redir('ls', '=>g:buffer_list')
funct! Redir(command, to)
  exec 'redir '.a:to
  exec a:command
  redir END
endfunct
" The last non-space substring is passed as the redirection target.
" EG
"   :R ls @">
"   " stores the buffer list in the 'unnamed buffer'
" Redirections to variables or files will work,
"   but there must not be a space between the redirection operator and the variable name.
" Also note that in order to redirect to a global variable you have to preface it with `g:`.
"   EG
"     :R ls =>g:buffer_list
"     :R ls >buffer_list.txt
command! -nargs=+ R call call(function('Redir'), split(<q-args>, '\s\(\S\+\s*$\)\@='))

" Seamless navigation between tmux panes and vim splits with 'Ctrl+h/j/k/l'
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    silent! execute "wincmd " . a:wincmd
    if previous_winnr == winnr()
      call system("tmux select-pane -" . a:tmuxdir)
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te

  nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
  nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
  nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
  nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
  map <C-h> <C-w>h
  map <C-j> <C-w>j
  map <C-k> <C-w>k
  map <C-l> <C-w>l
endif

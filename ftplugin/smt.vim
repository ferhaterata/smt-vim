if !exists("g:smtvim_solver_command")
    let g:smtvim_solver_command = "z3"
endif

function! SmtVimCompileAndRunFile()
    silent !clear
    execute "!cd " . expand('%:p:h') 
    execute "!" . g:smtvim_solver_command . " " . bufname("%")
endfunction

"nnoremap <buffer> <localleader>r :call SmtVimCompileAndRunFile()<cr>
nnoremap <buffer> <localleader>r :call SmtVimShowResult('')<cr>
nnoremap <buffer> <localleader>rs :call SmtVimShowResult('-st')<cr>

if exists('*SmtVimShowResult')
    finish
endif

function! SmtVimShowResult(args)
    " Get the result.
    let result = system("cd " . expand('%:p:h') . ";" . g:smtvim_solver_command . " " . bufname("%") . " " . a:args)
    
    let buffername = '_SMT_Solver_Results_' 
    
    let bnr = bufwinnr(buffername)
    
    if bnr > 0
       :exe bnr . "wincmd w"
       echo 'jumped to the buffer'
    else
       " Buffer is not existent'
       " Open a new split and set it up.
       silent execute 'vsplit ' . buffername
       let bnr = bufwinnr(buffername)
       " Decrease the window size by 0.67
       silent execute 'vertical resize ' . (winwidth(bnr) * 2/3)
    endif
    
    normal! ggdG
    setlocal filetype=smt
    setlocal buftype=nofile

    " Insert the bytecode.
    call append(0, split(result, '\v\n'))
    normal! gg
    
endfunction

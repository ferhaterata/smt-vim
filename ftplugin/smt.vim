if !exists("g:smtvim_solver_command")
    let g:smtvim_solver_command = "z3"
endif

function! SmtVimCompileAndRunFile()
    silent !clear
    execute "!cd " . expand('%:p:h') 
    execute "!" . g:smtvim_solver_command . " " . bufname("%")
endfunction

if exists('*SmtVimShowResult')
    finish
endif

function! SmtVimShowResult()
    " Get the result.
    let result = system("cd " . expand('%:p:h') . ";" . g:smtvim_solver_command . " " . bufname("%"))
    
    let buffername = '_SMT_Solver_Results_' 
    
    let bnr = bufwinnr(buffername)
    
    if bnr > 0
       :exe bnr . "wincmd w"
       echo 'jumped to the buffer'
    else
       " Buffer is not existent'
       " Open a new split and set it up.
       silent execute 'vsplit ' . buffername
    endif
    
    normal! ggdG
    setlocal filetype=smt
    setlocal buftype=nofile

    " Insert the bytecode.
    call append(0, split(result, '\v\n'))
endfunction

"nnoremap <buffer> <localleader>r :call SmtVimCompileAndRunFile()<cr>
nnoremap <buffer> <localleader>r :call SmtVimShowResult()<cr>

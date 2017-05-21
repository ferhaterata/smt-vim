if !exists("g:smtvim_solver_command")
    let g:smtvim_solver_command = "z3"
endif

function! SmtVimCompileAndRunFile()
    silent !clear
    execute "!cd " . expand('%:p:h') 
    execute "!" . g:smtvim_solver_command . " " . bufname("%")
endfunction

function! SmtVimShowResult()
    " Get the result.
    let result = system("cd " . expand('%:p:h') . ";" . g:smtvim_solver_command . " " . bufname("%"))

    " Open a new split and set it up.
    vsplit __SMT_Solver_Results__
    normal! ggdG
    setlocal filetype=smt
    setlocal buftype=nofile

    " Insert the bytecode.
    call append(0, split(result, '\v\n'))
endfunction

"nnoremap <buffer> <localleader>r :call SmtVimCompileAndRunFile()<cr>
nnoremap <buffer> <localleader>r :call SmtVimShowResult()<cr>

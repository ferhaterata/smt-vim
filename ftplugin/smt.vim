if !exists("g:smtvim_solver_command")
    let g:smtvim_solver_command = "z3"
endif

function! SmtVimCompileAndRunFile()
    silent !clear
    execute "!cd " . expand('%:p:h') 
    execute "!" . g:smtvim_solver_command . " " . bufname("%")
endfunction

nnoremap <buffer> <localleader>r :call SmtVimCompileAndRunFile()<cr>

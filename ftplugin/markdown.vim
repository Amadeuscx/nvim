" 定义一些task相关高亮
" 例如 - [ ] 任务内容 D:2023-04-25 S:2023-04-25 
hi MDTask ctermfg=1
hi MDDoneText ctermfg=37 cterm=italic,strikethrough
hi MDTodoText cterm=NONE
hi MDDoneDate cterm=strikethrough ctermfg=71
hi MDTodoDate ctermfg=71
hi Deadline ctermfg=162 cterm=bold,underline
hi NearDeadline ctermfg=178 cterm=bold
au FileType markdown syn match markdownError "\w\@<=\w\@="
au FileType markdown syn match MDDoneDate /[SD]:\d\{4\}\([\/-]\d\d\)\{2\}/ contained
au FileType markdown syn match MDTodoDate /[SD]:\d\{4\}\([\/-]\d\d\)\{2\}/ contained
au FileType markdown syn match MDDoneText /- \[x\] \zs.*/ contains=MDDoneDate contained
au FileType markdown syn match MDTodoText /- \[ \] \zs.*/ contains=MDTodoDate contained
au FileType markdown syn match MDTask     /- \[\(x\| \)\] .*/ contains=MDDoneText,MDTodoText
au FileType markdown call matchadd('Deadline', 'D:'.strftime("%Y-%m-%d"))
au FileType markdown call matchadd('NearDeadline', 'D:'.strftime("%Y-%m-%d", localtime() + 3600 * 24))
au FileType markdown call matchadd('NearDeadline', 'D:'.strftime("%Y-%m-%d", localtime() + 3600 * 48))

" 定义代码块高亮
hi MDCode ctermbg=236
hi MDCodeBlock ctermbg=234
hi MDCodeBlockHeader ctermbg=235
hi MDCodeBlockFoot ctermbg=235
au FileType markdown syn match MDCode /`.\+`/
au FileType markdown syn match MDCodeBlockHeader /^```.\+$/
au FileType markdown syn match MDCodeBlockFoot /^```$/
" au FileType markdown syn region MDCodeBlock start=/^```.\+$/ end=/^```$/ keepend contains=ALL concealends

let b:md_block = '```'
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
nnoremap <silent><buffer> <CR>   :call <SID>toggleTodoStatus()<CR><CR>
nnoremap <silent><buffer> <2-LeftMouse> :call <SID>toggleTodoStatus()<CR>:w<CR><2-LeftMouse>
vnoremap <silent><buffer> B      :<c-u>call SurroundVaddPairs("**", "**")<cr>
vnoremap <silent><buffer> I      :<c-u>call SurroundVaddPairs("*", "*")<cr>
vnoremap <silent><buffer> T      :<c-u>call SurroundVaddPairs("- [ ] ", "")<cr>
vnoremap <silent><buffer> `      :<c-u>call SurroundVaddPairs("`", "`")<cr>
vnoremap <silent><buffer> C      :<c-u>call SurroundVaddPairs("```plaintext", "```")<cr>

fun! s:toggleTodoStatus()
    let line = getline('.')
    if line =~ glob2regpat('*- \[ \]*')
        call setline('.', substitute(line, '\[ \]', '[x]', ''))
    elseif line =~ glob2regpat('*- \[x\]*')
        call setline('.', substitute(line, '\[x\]', '[ ]', ''))
    endif
endf

nnoremap <silent><buffer> <F6> :call <SID>toggleMPTheme()<CR>
inoremap <silent><buffer> <F6> <ESC>:call <SID>toggleMPTheme()<CR>
fun! s:toggleMPTheme()
    if g:mkdp_theme == 'dark'
        let g:mkdp_theme = 'light'
    else
        let g:mkdp_theme = 'dark'
    endif

    exec 'MarkdownPreviewStop'
    sleep 1
    exec 'MarkdownPreview'
endf

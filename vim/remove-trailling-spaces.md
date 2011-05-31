# Vim: удаление trailing spaces

Для удаления trailing spaces можно воспользоваться такой командой:

    :%s/\s*$//g

Так же удобно повесить ее на горячу клавишу:

    map <silent> <Leader>ts :%s/\s*$//g<CR>

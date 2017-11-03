command! PlayChips :call s:play_chips()

let g:chips_5 = '-'

function! s:Build2DArray(n,m,v)
  let res=[]
  for i in range(a:n)
    let row=[]
    for j in range(a:m)
      call add(row,a:v)
    endfor
    call add(res,row)
  endfor
  return res
endfunction

let s:rn = 15
let s:cn = 30
let s:chips = s:Build2DArray(s:rn, s:cn, g:chips_5)
let s:select = []
for j in range(s:cn)
    call add(s:select, ' ')
endfor
let s:sc = 0
let s:select[s:sc] = '*'
let s:take = 0
let s:chips_num = []
for j in range(s:cn)
    call add(s:chips_num, 5)
endfor

function! s:print()
    for j in range(s:cn)
        if j == s:sc
            if s:take > 0
                let s:select[j] = g:chips_5
            else
                let s:select[j] = '*'
            endif
        else
            let s:select[j] = ' '
        endif
    endfor
    for i in range(s:rn)
        for j in range(s:cn)
            if i >= s:rn - s:chips_num[j] || (i < s:take - 1 && j == s:sc)
                let s:chips[i][j] = g:chips_5
            else
                let s:chips[i][j] = ' '
            endif
        endfor
    endfor
    call setline(1, join(s:select, ''))
    for i in range(len(s:chips))
        let line=join(s:chips[i],'')
        call setline(i+2,line)
    endfor
endfunction

function! s:play_chips()
    let c = ''
    if bufname("%") != ''
        new
        resize 20
    endif
    call s:print()
    redraw
    while c != 'q'
        let c = nr2char(getchar())
        if c == 'h' || c == 'l'
            let nxtposition = c == 'h' ? max([0, s:sc - 1]) : min([s:cn - 1, s:sc + 1])
            let nextchips_num = s:chips_num[nxtposition] + s:take
            if nextchips_num > s:rn
                let s:chips_num[nxtposition] = s:rn
                let s:chips_num[s:sc] = s:chips_num[s:sc] + nextchips_num - s:rn
                let s:take = 0
            endif
            let s:sc = nxtposition
        elseif c == 'k'
            if s:chips_num[s:sc] > 0
                let s:take = s:take + 1
                let s:chips_num[s:sc] = s:chips_num[s:sc] - 1
            endif
        elseif c == 'j'
            if s:take > 0
                let s:chips_num[s:sc] = s:chips_num[s:sc] + s:take
                let s:take = 0
            endif
        endif
        call s:print()
        redraw
    endwhile
    :q!
endfunction

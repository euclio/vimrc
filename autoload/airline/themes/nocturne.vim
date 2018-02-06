scriptencoding utf-8

let g:airline#themes#nocturne#palette = {}
let g:airline#themes#nocturne#palette.accents = {
      \ 'red': [ '#ff2c4b' , '' , '' , '' , '' ]
      \ }

let s:N1 = ['#000000', '#afff00', '', '']
let s:N2 = ['#bdbdbd', '#1c1c1c', '', '']
let s:N3 = ['#bdbdbd', '#1c1c1c', '', '']
let g:airline#themes#nocturne#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#nocturne#palette.normal_modified = {
      \ 'airline_c': [ '#FFFF00', s:N3[1], '', ''] }

let s:I1 = ['#000000', '#00afff', '', '']
let s:I2 = s:N2
let s:I3 = s:N3
let g:airline#themes#nocturne#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#nocturne#palette.insert_modified = {
      \ 'airline_c': [ '#FFFF00', s:N3[1], '', ''] }

let s:V1 = ['#000000', '#ff8700', '', '']
let s:V2 = s:N2
let s:V3 = s:N3
let g:airline#themes#nocturne#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#nocturne#palette.visual_modified = {
      \ 'airline_c': [ '#FFFF00', s:N3[1], '', ''] }

let s:R1 = ['#000000', '#875fd7', '', '']
let s:R2 = s:N2
let s:R3 = s:N3
let g:airline#themes#nocturne#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#nocturne#palette.replace_modified = {
      \ 'airline_c': [ '#FFFF00', s:N3[1], '', ''] }

let s:IA1 = ['#616161', '#1c1c1c', '', '']
let s:IA2 = ['#616161', '#1c1c1c', '', '']
let s:IA3 = ['#616161', '#1c1c1c', '', '']
let g:airline#themes#nocturne#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#nocturne#palette.inactive_modified = {
      \ 'airline_c': [ '#FFFF00', s:N3[1], '', ''] }

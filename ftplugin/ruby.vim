setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab

setlocal foldmethod=indent

compiler ruby
setlocal makeprg=ruby\ -wc\ %

" surround area with <foo> (...) { }
if !exists('b:erb_loaded')
  let b:surround_{char2nr('i')} = "if \1if: \1 \r end"
  let b:surround_{char2nr('u')} = "unless \1unless: \1 \r end"
  let b:surround_{char2nr('w')} = "while \1while: \1 do \r end"
  let b:surround_{char2nr('e')} = "\1collection: \1.each do |\2item: \2| \r end"
  let b:surround_{char2nr('m')} = "module \r end"
  let b:surround_{char2nr('d')} = "do\n \r end"
endif

let b:surround_{char2nr(':')} = ":\r"
let b:surround_{char2nr('#')} = "#{\r}"
let b:surround_indent = 1

ConsoleCommand !irb -r'./%' <args>

DefineTagFinder Method f,method,F,singleton\ method
DefineTagFinder Module m,module

" Define a text object for block arguments (do |...|)
onoremap <buffer> i\| :<c-u>normal! T\|vt\|<cr>
xnoremap <buffer> i\| :<c-u>normal! T\|vt\|<cr>
onoremap <buffer> a\| :<c-u>normal! F\|vf\|<cr>
xnoremap <buffer> a\| :<c-u>normal! F\|vf\|<cr>

" Look up the word under the cursor on apidock:
nnoremap <buffer> gm :Doc ruby<cr>

" Evaluate and annotate the buffer through rcodetools
command! Annotate %!xmpfilter

if !exists('b:erb_loaded')
  let b:dh_closing_pattern = '^\s*end\>'

  " fold nicely -- experimental
  call RubyFold()
  setlocal nofoldenable

  if &ft == 'ruby'
    command! -buffer A exe "edit ".substitute(expand('%'), 'lib/\(.*\).rb', 'spec/\1_spec.rb', '')

    let b:outline_pattern = '\v^\s*(def|class|module|public|protected|private|(attr_\k{-}))(\s|$)'

    RunCommand !ruby % <args>

    command! -buffer R call s:R()
    if !exists('*s:R')
      function! s:R()
        let filename   = expand('%')
        let basename   = expand('%:t:r')
        let directory  = expand('%:h')
        let class_name = lib#CapitalCamelCase(basename)
        let pattern    = class_name.'\s\+<\s\+\(\k\+\)'

        call sj#PushCursor()

        if search(pattern)
          let parent_class = lib#ExtractRx(getline('.'), pattern, '\1')
          let parent_class_filename = lib#Underscore(parent_class)
          call sj#PopCursor()
          exe 'edit '.directory.'/'.parent_class_filename.'.rb'
        else
          call sj#PopCursor()
          echoerr "Parent class of ".class_name." not found"
        endif
      endfunction
    endif

    command! -buffer Init call s:Init()
    if !exists('*s:Init')
      function! s:Init()
        let args = split(lib#GetMotion('vi('), ',\s*')

        let assignments = []
        for arg in args
          let var = matchstr(arg, '^\k\+')
          call add(assignments, '@'.var.' = '.var)
        endfor

        let lineno = line('.')
        call append(lineno, assignments)
        let [start, end] = [lineno + 1, lineno + len(assignments)]

        exe start.','.end.'normal! =='
        call feedkeys('Vimsa=')
      endfunction
    endif

  endif
endif

if @% =~ 'step_definitions'
  let b:fswitchdst  = 'feature'
  let b:fswitchlocs = 'rel:..'

  let b:outline_pattern = '\v^\s*(Given|When|Then)'
endif

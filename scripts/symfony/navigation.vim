call symfony#LoadData()

command! -nargs=? -complete=customlist,symfony#CompleteJs Javascript call s:Javascript(<f-args>)
function! s:Javascript(...)
  if a:0 == 1 " Then we're given a filename
    let fname = fnamemodify(a:1, ':r').'.js'
    exe "edit web/js/".fname
  else
    exe
          \ 'edit web/js/'.
          \ symfony#CurrentAppName().
          \ '/'.
          \ symfony#CurrentModuleName().'.js'
  endif
endfunction

command! -nargs=? -complete=customlist,symfony#CompleteCss Stylesheet call s:Stylesheet(<f-args>)
function! s:Stylesheet(...)
  if a:0 == 1 " Then we're given a filename
    let fname = fnamemodify(a:1, ':r').'.css'
    exe "edit web/css/".fname
  else
    exe
          \ 'edit web/css/'.
          \ symfony#CurrentAppName().
          \ '/'.
          \ symfony#CurrentModuleName().'.css'
  endif
endfunction

command! -nargs=? View call s:View(<f-args>)
function! s:View(...)
  if expand('%:t') == 'actions.class.php'
    let filename = symfony#CurrentActionName().'Success.php'
  else " it's a component
    let filename = '_'.symfony#CurrentActionName().'.php'
  endif

  if a:0 == 1 " Then we're given a format specifier:
    let format = a:1
    let filename = fnamemodify(filename, ':r').'.'.format.'.php'
  endif

  exe
      \ 'edit apps/'.
      \ symfony#CurrentAppName().
      \ '/modules/'.
      \ symfony#CurrentModuleName().
      \ '/templates/'.
      \ filename
endfunction

command! -nargs=* -complete=customlist,symfony#CompleteModule Controller call s:Controller('action', <f-args>)
command! -nargs=* -complete=customlist,symfony#CompleteModule Component  call s:Controller('component', <f-args>)
function! s:Controller(type, ...)
  if (a:0 == 1) " Then we're given a controller
    let b:current_module_name = a:1
  elseif (a:0 == 2) " Then we're given a controller and an app
    let b:current_module_name = a:1
    let b:current_app_name = a:2
  endif

  let function_name = 'execute'.lib#Capitalize(symfony#CurrentActionName())

  exe
        \ 'edit apps/'.
        \ symfony#CurrentAppName().
        \ '/modules/'.
        \ symfony#CurrentModuleName().
        \ '/actions/'.a:type.'s.class.php'
  call cursor(0, 0)
  call search(function_name, 'cw')
endfunction
function! s:Component(...)
  if (a:0 == 1) " Then we're given a component
    let b:current_module_name = a:1
  endif

  let function_name = 'execute'.lib#Capitalize(symfony#CurrentActionName())

  exe
        \ 'edit apps/'.
        \ symfony#CurrentAppName().
        \ '/modules/'.
        \ symfony#CurrentModuleName().
        \ '/actions/components.class.php'
  call cursor(0, 0)
  call search(function_name, 'cw')
endfunction

command! -nargs=? -complete=customlist,symfony#CompleteModel Model  call s:Lib('model',  '',           <f-args>)
command! -nargs=? -complete=customlist,symfony#CompleteModel Table  call s:Lib('model',  'Table',      <f-args>)
command! -nargs=? -complete=customlist,symfony#CompleteModel Form   call s:Lib('form',   'Form',       <f-args>)
command! -nargs=? -complete=customlist,symfony#CompleteModel Filter call s:Lib('filter', 'FormFilter', <f-args>)
function! s:Lib(dir, suffix, ...)
  if a:0 == 0
    let b:model_name = symfony#CurrentModelName()
  else
    let b:model_name = a:1
  endif

  exe
        \ "edit lib/".
        \ a:dir.
        \ "/doctrine/".
        \ b:model_name.
        \ a:suffix.
        \ ".class.php"
endfunction

command! -nargs=? -complete=customlist,symfony#CompleteUnitTest Unit call s:Unit(<f-args>)
function! s:Unit(...)
  if a:0 == 1 " Then we're given a test name
    exe "edit test/unit/".lib#Lowercase(a:1)."Test.php"
  else " Dit a test according to current model name
    exe "edit test/unit/".lib#Lowercase(symfony#CurrentModelName())."Test.php"
  endif
endfunction

command! -nargs=* -complete=customlist,symfony#CompleteModule Functional call s:Functional(<f-args>)
function! s:Functional(...)
  if (a:0 == 1) " Then we're given a controller
    let b:current_module_name = a:1
  elseif (a:0 == 2) " Then we're given a controller and an app
    let b:current_module_name = a:1
    let b:current_app_name = a:2
  endif

  exe
        \ "edit test/functional/".
        \ symfony#CurrentAppName()."/".
        \ symfony#CurrentModuleName()."ActionsTest.php"
endfunction

command! -nargs=? -complete=customlist,symfony#CompleteSchema Schema call s:Schema(<f-args>)
function! s:Schema(...)
  if a:0 == 1 " Then we're given a prefix for the schema file
    let prefix = a:1.'_'
  else
    let prefix = ''
  endif

  exe "edit config/doctrine/".prefix."schema.yml"
endfunction

command! -nargs=1 -complete=customlist,symfony#CompleteFixture Fixture call s:Fixture(<f-args>)
function! s:Fixture(name)
  if exists('g:sf_fixture_dict[a:name]')
    let fixture = g:sf_fixture_dict[a:name]
  else
    let fixture = a:name
  endif

  exe 'edit data/fixtures/'.fixture
endfunction

command! -nargs=? -complete=customlist,symfony#CompleteApp Routing call s:Routing(<f-args>)
function! s:Routing(...)
  if a:0 == 1
    let b:current_app_name = a:1
  endif

  exe
      \ 'edit apps/'.
      \ symfony#CurrentAppName().
      \ '/config/routing.yml'
endfunction
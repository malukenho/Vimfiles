" This NERDTree plugin adds a filesystem manipulation menu exactly like the
" default one. The difference is that operations that require entering a file
" path, namely "add", "move" and "copy", use a separate one-line buffer to
" receive the input, instead of the default vim dialog. This allows you to use
" vim keybindings to move around the file path.
"
" vim: foldmethod=marker
if exists("g:loaded_nerdree_buffer_fs_menu")
  finish
endif
let g:loaded_nerdree_buffer_fs_menu = 1

call NERDTreeAddMenuItem({
      \ 'text':     '(a)dd a childnode',
      \ 'shortcut': 'a',
      \ 'callback': 'NERDTreeAddNodeWithTemporaryBuffer'
      \ })
call NERDTreeAddMenuItem({
      \ 'text':     '(m)ove the current node',
      \ 'shortcut': 'm',
      \ 'callback': 'NERDTreeMoveNodeWithTemporaryBuffer'
      \ })
call NERDTreeAddMenuItem({
      \ 'text':     '(d)elete the curent node',
      \ 'shortcut': 'd',
      \ 'callback': 'NERDTreeDeleteNode'
      \ })
if g:NERDTreePath.CopyingSupported()
  call NERDTreeAddMenuItem({
        \ 'text':     '(c)opy the current node',
        \ 'shortcut': 'c',
        \ 'callback': 'NERDTreeCopyNodeWithTemporaryBuffer'
        \ })
endif

"FUNCTION: NERDTreeMoveNodeWithTemporaryBuffer(){{{1
function! NERDTreeMoveNodeWithTemporaryBuffer()
  let current_node = g:NERDTreeFileNode.GetSelected()
  let path         = current_node.path.str()

  call <SID>SetupMenuBuffer(current_node, path)

  setlocal statusline=Move

  " setup callback
  nmap <buffer> <cr> :call <SID>ExecuteMove(b:current_node, getline('.'))<cr>
  imap <buffer> <cr> <esc>:call <SID>ExecuteMove(b:current_node, getline('.'))<cr>
endfunction

"FUNCTION: s:ExecuteMove(current_node, new_path){{{1
function! s:ExecuteMove(current_node, new_path)
  let current_node = a:current_node
  let new_path     = a:new_path

  " close the temporary buffer
  q!

  try
    let bufnum = bufnr(current_node.path.str())

    call current_node.rename(new_path)
    call NERDTreeRender()

    " if the node is open in a buffer, ask the user if they want to close that
    " buffer
    if bufnum != -1
      let prompt = "\nNode renamed.\n\n"
      let prompt .= "The old file is open in buffer ". bufnum . (bufwinnr(bufnum) ==# -1 ? " (hidden)" : "") . '.'
      let prompt .= "Delete this buffer? (yN)"

      call s:promptToDelBuffer(bufnum, prompt)
    endif

    call current_node.putCursorHere(1, 0)

    redraw!

    call s:echo('Node moved to '.new_path)
  catch /^NERDTree/
    call s:echoWarning("Node Not Renamed.")
  endtry
endfunction

"FUNCTION: NERDTreeAddNodeWithTemporaryBuffer(){{{1
function! NERDTreeAddNodeWithTemporaryBuffer()
  let current_node = g:NERDTreeDirNode.GetSelected()
  let path         = current_node.path.str({'format': 'Glob'}) . g:NERDTreePath.Slash()

  call <SID>SetupMenuBuffer(current_node, path)

  setlocal statusline=Add

  " setup callback
  nmap <buffer> <cr> :call <SID>ExecuteAdd(b:current_node, getline('.'))<cr>
  imap <buffer> <cr> <esc>:call <SID>ExecuteAdd(b:current_node, getline('.'))<cr>
endfunction

"FUNCTION: s:ExecuteAdd(current_node, new_node_name){{{1
function s:ExecuteAdd(current_node, new_node_name)
  let current_node  = a:current_node
  let new_node_name = a:new_node_name

  " close the temporary buffer
  q!

  if new_node_name ==# ''
    call s:echo("Node Creation Aborted.")
    return
  endif

  try
    let new_path    = g:NERDTreePath.Create(new_node_name)
    let parent_node = b:NERDTreeRoot.findNode(new_path.getParent())

    let new_tree_node = g:NERDTreeFileNode.New(new_path)
    if parent_node.isOpen || !empty(parent_node.children)
      call parent_node.addChild(new_tree_node, 1)
      call NERDTreeRender()
      call new_tree_node.putCursorHere(1, 0)
    endif

    call s:echo('Node created as ' . new_node_name)
  catch /^NERDTree/
    call s:echoWarning("Node Not Created.")
  endtry
endfunction

"FUNCTION: NERDTreeCopyNodeWithTemporaryBuffer() {{{1
function! NERDTreeCopyNodeWithTemporaryBuffer()
  let current_node = g:NERDTreeFileNode.GetSelected()
  let path         = current_node.path.str()

  call <SID>SetupMenuBuffer(current_node, path)

  setlocal statusline=Copy

  " setup callback
  nmap <buffer> <cr> :call <SID>ExecuteCopy(b:current_node, getline('.'))<cr>
  imap <buffer> <cr> <esc>:call <SID>ExecuteCopy(b:current_node, getline('.'))<cr>
endfunction

"FUNCTION: s:ExecuteCopy(current_node, new_node_name){{{1
function! s:ExecuteCopy(current_node, new_path)
  let current_node = a:current_node
  let new_path     = a:new_path

  " close the temporary buffer
  q!

  if new_path != ""
    "strip trailing slash
    let new_path = substitute(new_path, '\/$', '', '')

    let confirmed = 1
    if current_node.path.copyingWillOverwrite(new_path)
      call s:echo("Warning: copying may overwrite files! Continue? (yN)")
      let choice = nr2char(getchar())
      let confirmed = choice ==# 'y'
    endif

    if confirmed
      try
        call s:echo("Copying...")
        let new_node = current_node.copy(new_path)
        call NERDTreeRender()
        call new_node.putCursorHere(0, 0)
        call s:echo("Copied to " . new_path)
      catch /^NERDTree/
        call s:echoWarning("Could not copy node")
      endtry
    endif
  else
    call s:echo("Copy aborted.")
  endif
  redraw
endfunction

"FUNCTION: s:SetupMenuBuffer(current_node, path){{{1
function! s:SetupMenuBuffer(current_node, path)
  let current_node = a:current_node
  let path         = a:path

  " one-line buffer, below everything else
  botright 1new

  " check for automatic completion and temporarily disable it
  if exists(':AcpLock')
    AcpLock
    autocmd BufLeave <buffer> AcpUnlock
  endif

  autocmd BufLeave <buffer> q!

  call setline(1, path)
  setlocal nomodified
  let b:current_node = current_node

  " guard against problems
  nmap <buffer> o <nop>
  nmap <buffer> O <nop>

  " cancel action
  nmap <buffer> <esc> :q!<cr>
  nmap <buffer> <c-[> :q!<cr>
  nmap <buffer> <c-c> :q!<cr>
  imap <buffer> <c-c> :q!<cr>

  " go to the end of the filename, ready to type
  call feedkeys('A')
endfunction

" FUNCTION: NERDTreeDeleteNode() {{{1
function! NERDTreeDeleteNode()
    let currentNode = g:NERDTreeFileNode.GetSelected()
    let confirmed = 0

    if currentNode.path.isDirectory
        let choice =input("Delete the current node\n" .
                         \ "==========================================================\n" .
                         \ "STOP! To delete this entire directory, type 'yes'\n" .
                         \ "" . currentNode.path.str() . ": ")
        let confirmed = choice ==# 'yes'
    else
        echo "Delete the current node\n" .
           \ "==========================================================\n".
           \ "Are you sure you wish to delete the node:\n" .
           \ "" . currentNode.path.str() . " (yN):"
        let choice = nr2char(getchar())
        let confirmed = choice ==# 'y'
    endif


    if confirmed
        try
            call currentNode.delete()
            call NERDTreeRender()

            "if the node is open in a buffer, ask the user if they want to
            "close that buffer
            let bufnum = bufnr(currentNode.path.str())
            if buflisted(bufnum)
                let prompt = "\nNode deleted.\n\nThe file is open in buffer ". bufnum . (bufwinnr(bufnum) ==# -1 ? " (hidden)" : "") .". Delete this buffer? (yN)"
                call s:promptToDelBuffer(bufnum, prompt)
            endif

            redraw
        catch /^NERDTree/
            call s:echoWarning("Could not remove node")
        endtry
    else
        call s:echo("delete aborted")
    endif
endfunction

"FUNCTION: s:echo(msg){{{1
function! s:echo(msg)
  redraw
  echomsg "NERDTree: " . a:msg
endfunction

"FUNCTION: s:echoWarning(msg){{{1
function! s:echoWarning(msg)
  echohl warningmsg
  call s:echo(a:msg)
  echohl normal
endfunction

"FUNCTION: s:promptToDelBuffer(bufnum, msg){{{1
"prints out the given msg and, if the user responds by pushing 'y' then the
"buffer with the given bufnum is deleted
"
"Args:
"bufnum: the buffer that may be deleted
"msg: a message that will be echoed to the user asking them if they wish to
"     del the buffer
function! s:promptToDelBuffer(bufnum, msg)
  echo a:msg
  if nr2char(getchar()) ==# 'y'
    exec "silent bdelete! " . a:bufnum
  endif
endfunction

This project is my vim setup. It's intended to work on a Linux box with a vim
compiled with `+ruby` and `+python`, though it should load just fine even
otherwise, only with less features.

To try it out, backup your `.vimrc` and your `.vim` directory and checkout this
repository as `~/.vim`. Afterwards, create a symbolic link from `~/.vim/.vimrc`
to `~/.vimrc` and checkout all submodules:

    git clone git://github.com/AndrewRadev/Vimfiles.git ~/.vim
    ln -s ~/.vim/.vimrc ~/.vimrc
    cd ~/.vim
    git submodule init
    git submodule update

Occasionally, I remap built-in mappings, so use with caution, and preferably
read "[startup/mappings.vim][]" beforehand to avoid nasty surprises.

Alternatively, you can read and selectively pick stuff for your own
configuration, which I highly recommend. A short guide to where you can find
most of my customizations follows below. If you'd like to know more details on
my work with vim, you can take a look at posts categorized with "vim"
[in my blog](http://andrewradev.com/categories/vim/).
If you're interested in vim plugins I've published, you can find a list on my
[vim.org profile page](http://www.vim.org/account/profile.php?user_id=31799).

## Startup

The "[startup][]" directory is basically my `.vimrc`, except separated into
mappings, settings and so on. The borders between a few things are blurry,
though. The reason they're not in `plugin` is because it's necessary to either
load them very early or load them in a specific order. Or, they just haven't
made sense to me as "plugins".

## Personal

The "[personal][]" directory contains small scripts that I don't consider good
plugin material, but are useful anyway.

## WIP

The "[wip][]" directory contains stuff that I'm currently working on. These will
probably be incomplete experiments that I can't build plugins from just yet.

## Projects

The "[projects][]" directory holds "project" files. I use this in combination
with the [proj plugin][] to load some project-specific settings depending on
what I'm working on right now. The symfony project file might be my largest,
but it's abandoned, since I'm not writing PHP anymore.

## Nerdtree plugins

The "[nerdtree_plugin][]" directory is not the stock one that comes with the
NERDTree plugin. It contains a few of my own scripts and some modified stock
ones, the most interesting of which might be the buffer menu in
[nerdtree_plugin/fs_buffer_menu.vim][].

## Filetype-specific stuff

A lot of interesting things can be found in the "[ftplugin][]" directory. I
occasionally build useful stuff for filetypes I use often. These are probably
not very generic or redistributable, which is why I tend to put them there.

## Other

- The file "[autoload/lib.vim][]" contains (mostly) general-purpose functions
  I've felt could be useful in various places.
- The file "[colors/andrew.vim][]" is my personal colorscheme, which is a
  modified elflord.
- The "[after][]" directory may contain some interesting things that had to be
  placed there for late loading.

[after]:                              https://github.com/AndrewRadev/Vimfiles/tree/master/after
[autoload/lib.vim]:                   https://github.com/AndrewRadev/Vimfiles/tree/master/autoload/lib.vim
[colors/andrew.vim]:                  https://github.com/AndrewRadev/Vimfiles/tree/master/colors/andrew.vim
[ftplugin]:                           https://github.com/AndrewRadev/Vimfiles/tree/master/after
[nerdtree_plugin/fs_buffer_menu.vim]: https://github.com/AndrewRadev/Vimfiles/tree/master/nerdtree_plugin/fs_buffer_menu.vim
[nerdtree_plugin]:                    https://github.com/AndrewRadev/Vimfiles/tree/master/nerdtree_plugin
[personal]:                           https://github.com/AndrewRadev/Vimfiles/tree/master/personal
[projects]:                           https://github.com/AndrewRadev/Vimfiles/tree/master/projects
[startup/mappings.vim]:               https://github.com/AndrewRadev/Vimfiles/tree/master/startup/mappings.vim
[startup]:                            https://github.com/AndrewRadev/Vimfiles/tree/master/startup
[wip]:                                https://github.com/AndrewRadev/Vimfiles/tree/master/wip

[proj plugin]: http://www.vim.org/scripts/script.php?script_id=2719

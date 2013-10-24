#Vim Settings

I set up a repository to easily sync my Vim settings across multiple computers.
This setup takes advantage of the NeoBundle plugin to automatically install,
manage and update plugins. In the case that NeoBundle is not installed, I have
written some code in `bundles.vim` that automatically clones its repository.

#Set Up

##OSX/Unix

Open up a terminal and enter the following commands:

    cd
    git clone https://github.com/euclio/vim-settings.git .vim

If running Vim 7.4, you're done. Otherwise, enter

    ln -s .vim/vimrc .vimrc
    ln -s .vim/gvimrc .gvimrc

##Windows

Open up cmd.exe and enter the following commands:

    cd %USERPROFILE%
    git clone https://github.com/euclio/vim-settings.git vimfiles

If running Vim 7.4, you're done. Otherwise, enter

    copy vimfiles\win\_vimrc .
    copy vimfiles\win\_gvimrc .

These files are very minimal scripts that simply source the actual files. This
is because Vim does not treat symlinks the same way that it does on other
platforms. It is easiest to simply source the real files that attempt to link
them. The actual `.vimrc` maintains `$MYVIMRC` and `$MYGVIMRC` to keep track of
the actual files.

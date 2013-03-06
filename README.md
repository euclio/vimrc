#Vim Settings
I set up a repository to easily sync my vim settings across multiple 
computers. This setup takes advantage of the pathogen plugin to keep plugins in
their own directories, and thus easily syncable. 

#Set Up
First, I initialized a git repository in the `~/.vim/` folder. Then, I moved my
 old `.vimrc into the `.vim` folder and created a symbolic link from the 
dotfile in the home directory to the one in the repository with the following
commands:

    cd
    ln -s .vim/.vimrc .vimrc

On Windows, the command is:

    cd
    mklink _vimrc vimfiles\.vimrc

The same process must be followed for the .gvimrc for GUI settings.

Keeping my vim settings the same across computers is now as easy as executing
`:BundleInstall!` while inside vim. I have included a vimscript that will set
up Vundle on first installation, and update all plugins to simplify the 
process of cloning vim settings into new computers.

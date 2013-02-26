#Vim Settings
I set up a repository to easily sync my vim settings across multiple 
computers. This setup takes advantage of the pathogen plugin to keep plugins in
their own directories, and thus easily syncable. 

#Set Up
First, I initialized a git repository in the `~/.vim/` folder. Then, I moved my
 old `.vimrc into the `.vim` folder and created a symbolic link from the 
dotfile in the home directory to the one in the repository. With the following
commands:

    cd
    ln -s .vim/.vimrc .vimrc

On Windows, symbolic links are not as well supported. So, I made a hard link
instead:

    cd
    mklink /H _vimrc vimfiles\.vimrc

Keeping my vim settings the same across computers is now as easy as executing a 
git clone.

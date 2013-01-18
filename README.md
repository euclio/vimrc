#`vim` Settings
I set up a repository to easily sync my `vim` settings across multiple 
computers. The steps required to do this are relatively simple. First, I
initialized a git repository in the `~/.vim/` folder. Then, I linked the
`.vimrc` inside the home folder to the one inside the repository. This is done
with the following commands:

    cd
    ln -s .vim/.vimrc .vimrc

Now my `vim` settings are updated with a `git pull` followed by a `git push`.

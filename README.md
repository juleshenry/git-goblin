# git-goblin
Git Scripts that Get the Job Done!

![alt text](https://www.publicdomainpictures.net/pictures/200000/velka/goblin-on-corona.jpg)

# gacp
Simplifies clunky common pattern of adding all changes, committing and pushing.

E.g. `gacp "New Form on HomePage"`


There are two ways to add your shell script to your PATH:
1. Move the shell script to a directory that is already in your PATH. 

Inspect `echo $PATH`-> `/Library/Frameworks/Python.framework/Versions/3.10/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin`. Then, for example: `sudo mv gacp /usr/bin`


2. Add the shell script's directory to your PATH

Then, add like so: `export PATH=$PATH:/home/jdoe/myscripts`

# rec-autosave
Runs around cleaning up uncommitted projects.

Script is aggressive, recurse everywhere and perform
`gacp "autosave $(date)"`, provided `(git status | tail -n 1 )` matches regex indicating update needed


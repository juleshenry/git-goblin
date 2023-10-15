# git-goblin
Git Scripts that Get the Job Done!

![alt text](https://www.publicdomainpictures.net/pictures/200000/velka/goblin-on-corona.jpg)

# gacp
Simplifies clunky common pattern of adding all changes, committing and pushing.
E.g. `gacp "New Form on HomePage"`


There are two ways to add your shell script to your PATH:
1. Move the shell script to a directory that is already in your PATH. 

Navigate your terminal to the gitgoblin root.
`echo "$(pwd)\gacp`
`nano ~/.bashrc OR nano ~/.zshrc`
`alias myalias='gacp'` 
`source ~/.bashrc OR source ~/.zshrc` 

# rec-autosave
Runs around cleaning up uncommitted projects.

Script is aggressive, recurse everywhere and perform
`gacp "autosave $(date)"`, provided `(git status | tail -n 1 )` matches regex indicating update needed


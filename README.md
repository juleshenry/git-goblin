# git-goblin
Git Scripts that Get the Job Done!

![ggob.jpeg](ggob.jpeg)

To add any script to your path... for example, gacp.

Navigate your terminal to the gitgoblin root.
`echo "$(pwd)\gacp`
`nano ~/.bashrc OR nano ~/.zshrc`
`alias myalias='$PATH_TO_GITGOBLIN/git-goblin-gacp'` 
`source ~/.bashrc OR source ~/.zshrc` 
`chmod 700 gacp`
GOOD TO GO!

# gg
## (aka 'gacp' aka 'gush')
Simplifies clunky common pattern of adding all changes, committing and pushing.
E.g. `gg "New Form on HomePage"`

# h 
## (history|grep $1)
would you like to grep history on the fly? `h` that joint!!

# autosave-git-recursively.py
When called, recurses all child folders and git pushes with the message "Autosave $GMT_DateTime"

# git-goblin.py
pipe this into .$$rc to quickly initialize git-goblin

# date-file-maker
Makes a text file of as $GMT_DateTime.txt

# ds-store-duster
Recurses all child folders and removes .DS_Store

# dust-kash
Recurses all child folders and removes .kash

# kash
Python decorator that caches results based on parameters


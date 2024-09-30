# git-goblin
Git Scripts that Get the Job Done!

To add any script to your path... for example, gacp.

Navigate your terminal to the gitgoblin root.
`echo "$(pwd)\gacp`
`nano ~/.bashrc OR nano ~/.zshrc`
`alias myalias='$PATH_TO_GITGOBLIN/git-goblin-gacp'` 
`source ~/.bashrc OR source ~/.zshrc` 
`chmod 777 gacp`
GOOD TO GO!

# gacp
Simplifies clunky common pattern of adding all changes, committing and pushing.
E.g. `gacp "New Form on HomePage"`


# git-autosave-recursively.py
When called, recurses all child folders and git pushes with the message "Autosave $GMT_DateTime"

# date-file-maker
Makes a text file of as $GMT_DateTime.txt

# ds-store-duster
Recurses all child folders and removes .DS_Store

# dust-kash
Recurses all child folders and removes .kash

# kash
Python decorator that caches results based on parameters


import os
import subprocess

def unseen(gfc, dir):
    for cached in gfc:
        if cached in dir:
            return 0
    return 1

def change_directory_and_run_command(directory):
    gacp = "git add .; git commit -m 'Autosaving... $(date)';git push"
    rez = subprocess.run([f'cd {directory}; zsh -i -c "{gacp }"'], shell=True)
    print(rez.stdout)

def recurse_directories(base_path):
    gitful_cache = set() # dirs with git in them
    for root, dirs, files in os.walk(base_path):
        for d in dirs:
            command = os.path.join(root, d)
            # checks if in a Git repo
            if unseen(gitful_cache, command) and '.git' in str(command):
                gitful_cache.add(command)
                place=(command[2:-4])
                change_directory_and_run_command(place)

if __name__ == "__main__":
    base_path = "."  # Starting directory (current directory)
    recurse_directories(base_path)

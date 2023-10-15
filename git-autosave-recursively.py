import os
import subprocess

def unseen(gfc, dir):
    for cached in gfc:
        if cached in dir:
            return 0
    return 1

def recurse_directories(base_path):
    gitful_cache = set() # dirs with git in them
    true_root = os.getcwd()
    for root, dirs, files in os.walk(base_path):
        
        for d in dirs:
            command = os.path.join(root, d)
            # checks if in a Git repo
            if unseen(gitful_cache, command) and '.git' in str(command):
                gitful_cache.add(command)
                # print('Git repo discovered     @', command[:-5])
                cmd=(true_root + command[1:-4])
                print(cmd)
                subprocess.run(['cd ' + cmd,  "gacp 'Autosaving... $(date)'"])

if __name__ == "__main__":
    base_path = "."  # Starting directory (current directory)
    recurse_directories(base_path)

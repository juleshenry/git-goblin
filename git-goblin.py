import os
alias_files = []
with open("README.md") as s:
    for o in sorted(s.readlines()):
        if "#" in o and "py" not in o and "##" not in o and "git-goblin" not in o:
            print(f"alias {(g:=o.split('#')[1][1:-1])}={os.getcwd()}/git-goblin/{g}")
            alias_files+=[g]
print('chmod +x '+ ' '.join(list(alias_files)))
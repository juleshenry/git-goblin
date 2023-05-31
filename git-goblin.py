import subprocess
import sys

def gpush():
    try:
        subprocess.check_call(["git","push"])
    except subprocess.CalledProcessError as scpe:
        print(scpe)
        # print("ASDF")
gpush()

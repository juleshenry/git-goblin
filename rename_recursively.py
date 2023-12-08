import os
import argparse

def rename_files(path):
    for root, dirs, files in os.walk(path):
        for file in files:
            old_path = os.path.join(root, file)
            new_name = file[-5:]
            new_path = os.path.join(root, new_name)
            os.rename(old_path, new_path)

def main():
    parser = argparse.ArgumentParser(description='Recursively rename files to their last 5 characters.')
    parser.add_argument('directory', help='Path to the directory containing the files')

    args = parser.parse_args()
    directory_path = args.directory

    rename_files(directory_path)

if __name__ == '__main__':
    main()

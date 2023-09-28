import requests
# For a given user, find all open issues for all repos

def get_open_issues(repo):
    url = f"https://api.github.com/repos/{repo}/issues"
    response = requests.get(url)

    if response.status_code == 200:
        issues = response.json()
        open_issues = [issue for issue in issues if issue['state'] == 'open']
        return open_issues
    else:
        print(f"Failed to fetch issues for {repo}. Status code: {response.status_code}")
        return []

def main(repositories):
    for repo in repositories:
        open_issues = get_open_issues(repo)
        if open_issues:
            print(f"Open issues in {repo}:")
            for ix,issue in enumerate(open_issues):
                if '.' in issue['title'][:5]:
                    tit = ''.join(issue['title'].split('.')[1:])
                print(f"{ix}. {tit} ({issue['html_url']})")

import subprocess
import requests

def get_public_repositories(username):
    url = f"https://api.github.com/users/{username}/repos"
    response = requests.get(url)

    if response.status_code == 200:
        repos = response.json()
        return repos
    else:
        print(f"Failed to fetch repositories for {username}. Status code: {response.status_code}")
        return []

def get_user_repos(username):
    repositories = get_public_repositories(username)
    
    if repositories:
        print(f"Public repositories for user {username}:")
        return [r['html_url']for r in repositories]
    else:
        print("No public repositories found.")

def clean_urls(x):
    return ['/'.join(s.split('/')[-2:]) for s in x]

if __name__ == "__main__":
    us = 'juleshenry'
    x = get_user_repos(us)
    if not x:
        print('API likely failed')
    y = clean_urls(x)
    main(y)

Because I'm afraid of somgthing wrong about the encoding-ways such as UTF-8 and GBK, I decide to write my `README.md` in English. Though it is some of tough for me, it's still a little fun and valuable.  

It's the first time for me to write `README.md` in English, haha  

# My dotfiles

## Description of files here
```text
.  
├── README.md                     something like introduction  
├── git  
│   └── .gitconfig                from ~/.gitconfig
├── install.sh  
└── terminal  
    └── .zshrc                    from ~/.zshrc  
```

## Introduction to the file `install.sh`  

> Because I'm not familiar with the grammer of <.sh> files, I use AI (actually DeepSeek) to help me to write this script.

(When the script is trying to execute commend `ln`, if there have been a file in the destination, the script will rename it as `{originalName}.bak`. And the script will always execute the commend `ln` with the flag of `-sf`.)  
(The script is written mainly for the scene that I am trying to use a new cloud server.)  

- The script will ask the users whether to use a customised hostname in the prompt. (Won't change the real hostname.) Because I don't like the default hostname of the cloud machine which I get from the cloud company
- The script will `sudo apt update` and then `sudo apt install -y zsh neofetch tree build-essential gdb p7zip-full curl git wget`, because I think they are necessary for me. 
- The script will install `Oh My Zsh` from GitHub, because I like it.
- The script will install zsh plugins `zsh-autosuggestions` and `zsh-syntax-highlighting` from Gitee, because I suppose they are necessary for me. (Gitee for the problem of network fluctuation, maybe. I also forget the reason why I chose Gitee at first.)
- The script will ask about your name and email and write them into the file `~/.gitconfig.local`, which won't be tracked by dotfiles, if the script don't find the existed name and email in the machine. And then the script will link the file `~/.gitconfig`, whilch will include `~/.gitconfig.local`.  
- The script will link the file `~/.zshrc`

## How to use it

### A new machine
```bash
cd     
    # I like to put the director <dotfiles> in home.
```
```bash
git clone https://github.com/Juster955/dotfiles.git
    # Maybe need to write your name and e-mail address for the first time.
```
```
./dotfiles/install.sh
    # execute the <install.sh>
```

### Change something in my main PC
- if change the content of dotfiles：
  - `vim` to change the file in `~/dotfiles`
- if download new softwares:
  - change the `install.sh`
- if add new dotfiles
  - `mv` to the director of `~/dotfiles`
  - `ln` to the original place
  - change the deploy part in the tail of `install.sh`
  - `git commit` and `push`
> remember to check if there are private contents before `git add`

### Update dotfiles in new machines
`git pull origin main`
`cd`
`./dotfiles/install.sh`

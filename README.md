Because I'm afraid of somgthing wrong about the encoding-ways such as UTF-8 and GBK, I decide to write my README.md in English. Though it is some of tough for me, it's still a little fun and valuable.
It's the first time for me to write README.md in English, haha

# Description of files here
.
├── README.md                     something like introduction
├── install.sh
└── terminal
    └── .zshrc                    from ~/.zshrc


# Introduction to the file <install.sh>

> Because I'm not familiar with the grammer of <.sh> files, I use AI (actually DeepSeek) to help me to write this script.

(When the script is trying to execute commend <ln>, if there have been a file in the destination, the script will rename it as <{originalName}.bak>. And the script will always execute the commend <ln> with the flag of <-sf>.)
(The script is written mainly for the scene that I am trying to use a new cloud server.)

- The script will ask the users whether to use a customised hostname in the prompt. (Won't change the real hostname.) Because I don't like the default hostname of the cloud machine which I get from the cloud company
- The script will <sudo apt update> and then <sudo apt install -y zsh neofetch tree build-essentail gdb p7zip-full curl git wget>, because I think they are necessary for me. 
- The script will install Oh My Zsh from GitHub, because I like it.
- The script will install Zsh Plugins <zsh-autosuggestions> and <zsh-syntax-highlighting> from Gitee, because I suppose they are necessary for me. (Gitee for the problem of network fluctuation, maybe. I also forget the reason why I chose Gitee at first.)
- The script will link the files <~/.zshrc>

# How to use it

```bash
cd     
    # I like to put the director <dotfiles> in home.
git clone https://github.com/Juster955/dotfiles.git
    # Maybe need to write your name and e-mail address for the first time.
./dotfiles/install.sh
    # execute the <install.sh>
```

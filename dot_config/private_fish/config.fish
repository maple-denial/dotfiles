if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
end

# Homebrew
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)

# Homebrew 国内镜像（不需要可整段删除）
set -gx HOMEBREW_API_DOMAIN "https://mirrors.ustc.edu.cn/homebrew-bottles/api"
set -gx HOMEBREW_BOTTLE_DOMAIN "https://mirrors.ustc.edu.cn/homebrew-bottles"
set -gx HOMEBREW_NO_ANALYTICS 1

set -gx EDITOR nvim
set -gx VISUAL nvim
fish_add_path ~/.local/bin
#rustup
source "$HOME/.cargo/env.fish"

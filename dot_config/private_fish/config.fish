if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
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
test -f "$HOME/.cargo/env.fish"; and source "$HOME/.cargo/env.fish"

# ===== 开发期依赖搜索：brew 与系统库同时可见 =====
# 规则：以下路径按“书写顺序”优先——brew 在前（与 brew 软件的 ABI 一致），
# 系统在后兜底（brew 没有的包，如 libudev）。编译器自带的
# /usr/include、/usr/lib/x86_64-linux-gnu 仍在最后兜底，天然双搜索。
#
# pkg-config 搜索顺序 = PKG_CONFIG_PATH 顺序 → pkgconf 内置默认（brew）→ 系统兜底
set -gx PKG_CONFIG_PATH \
    /home/linuxbrew/.linuxbrew/lib/pkgconfig \
    /home/linuxbrew/.linuxbrew/share/pkgconfig \
    /usr/lib/x86_64-linux-gnu/pkgconfig \
    /usr/lib/pkgconfig \
    /usr/local/lib/pkgconfig \
    /usr/share/pkgconfig

# gcc/clang 找头文件：CPATH 排在编译器自带 -isystem 之前 → brew 头优先，/usr/include 自动兜底
set -gx CPATH /home/linuxbrew/.linuxbrew/include

# gcc/clang 找库(-L)：LIBRARY_PATH 排在编译器自带库路径之前 → brew 库优先，系统库自动兜底
set -gx LIBRARY_PATH /home/linuxbrew/.linuxbrew/lib

# 说明：刻意不设 LD_LIBRARY_PATH——brew 二进制自带 RPATH，运行期混链系统/ brew 库易出符号冲突；
# 确需运行期加载 brew 库的个别程序，单独按需启动：
#   LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib ./your_program



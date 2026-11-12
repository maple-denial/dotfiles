#!/usr/bin/env bash
# rebuild-loli-patch.sh —— 为 dsh-whale-loli 重建「config.id 英文化」pnpm 补丁
#
# 用法:
#   rebuild-loli-patch.sh [版本号]        # 不带参数则使用 registry 上的 latest
#
# 背景:
#   ~/.dsh/profiles/web/pnpm-workspace.yaml 的 patchedDependencies 给
#   dsh-whale-loli 挂了 patches/dsh-whale-loli.patch，把预设 config.id 从中文改成英文。
#   上游增删预设后旧补丁会失配，pnpm 12 报 ERR_PNPM_PATCH_FAILED 并回滚更新。
#   本脚本按目标版本重新生成补丁，并在包副本上 dry-run 验证。
#
# 之后仍需手动:
#   1) 改 package.json 里 "dsh-whale-loli" 的版本
#   2) cd ~/.dsh/profiles/web && pnpm install
#   3) 重启 DSH web
#   4) chezmoi add ~/.dsh/profiles/web/package.json ~/.dsh/profiles/web/pnpm-lock.yaml
set -euo pipefail

VERSION="${1:-}"
PROFILE_DIR="${PROFILE_DIR:-$HOME/.dsh/profiles/web}"
PATCH_PATH="$PROFILE_DIR/patches/dsh-whale-loli.patch"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

if [[ -z "$VERSION" ]]; then
  VERSION="$(curl -fsSL https://registry.npmjs.org/dsh-whale-loli/latest \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)["version"])')"
  echo "未指定版本，使用 registry latest: $VERSION"
fi

echo "下载 dsh-whale-loli@$VERSION ..."
curl -fsSL "https://registry.npmjs.org/dsh-whale-loli/-/dsh-whale-loli-$VERSION.tgz" \
  | tar -xz -C "$WORK"
PKG="$WORK/package"
[[ -f "$PKG/cordis.patch.yml" ]] || { echo "错误: 包内没有 cordis.patch.yml" >&2; exit 1; }

# 1) 替换 config.id（中文 → 英文）。只匹配 8 空格缩进的 `id:` 行。
cp "$PKG/cordis.patch.yml" "$WORK/orig.yml"
python3 - "$WORK" <<'PY'
import os, re, sys
work = sys.argv[1]
src = open(os.path.join(work, 'package/cordis.patch.yml'), encoding='utf-8').read()
pairs = [
    ('        id: 鲸鱼娘Agent预设\n',       '        id: whale-loli\n'),
    ('        id: 鲸鱼娘活人版Agent预设\n', '        id: whale-loli-live\n'),
    ('        id: 鲸鱼娘涩涩版Agent预设\n', '        id: whale-loli-naughty\n'),
    ('        id: 鲸鱼娘女儿版Agent预设\n', '        id: whale-loli-daughter\n'),
]
hit = 0
for old, new in pairs:
    if old in src:
        src = src.replace(old, new)
        hit += 1
    else:
        print(f'跳过（本版本没有该预设）: {old.strip()}')
leftover = re.findall(r'^        id: (?!whale-)[^\n]+\n', src, re.M)
for line in leftover:
    print(f'警告: 有未映射的 config.id 行: {line.strip()}')
open(os.path.join(work, 'b.yml'), 'w', encoding='utf-8').write(src)
print(f'已替换 config.id: {hit} 处')
PY

# 2) 生成 unified diff（--label 固定路径，去时间戳，内容稳定可复现）
mkdir -p "$WORK/a" "$WORK/b"
cp "$WORK/orig.yml" "$WORK/a/cordis.patch.yml"
cp "$WORK/b.yml"    "$WORK/b/cordis.patch.yml"
( cd "$WORK" && diff -u --label a/cordis.patch.yml --label b/cordis.patch.yml \
    a/cordis.patch.yml b/cordis.patch.yml > raw.patch ) || true
H1="$(git hash-object "$WORK/a/cordis.patch.yml")"
H2="$(git hash-object "$WORK/b/cordis.patch.yml")"
{
  printf 'diff --git a/cordis.patch.yml b/cordis.patch.yml\nindex %s..%s 100644\n' "$H1" "$H2"
  cat "$WORK/raw.patch"
} > "$WORK/new.patch"

# 3) 在目标版本副本上 dry-run 验证
cp -r "$PKG" "$WORK/check"
( cd "$WORK/check" && git apply --check "$WORK/new.patch" ) \
  || { echo "错误: 补丁无法应用到 $VERSION" >&2; exit 1; }

# 4) 写回
mkdir -p "$PROFILE_DIR/patches"
cp "$WORK/new.patch" "$PATCH_PATH"
echo "已写入: $PATCH_PATH ($(wc -c < "$PATCH_PATH") 字节)"
echo
echo "下一步:"
echo "  1) 修改 $PROFILE_DIR/package.json: \"dsh-whale-loli\": \"$VERSION\""
echo "  2) cd $PROFILE_DIR && pnpm install"
echo "  3) 重启 DSH web"
echo "  4) chezmoi add \$HOME/.dsh/profiles/web/package.json \$HOME/.dsh/profiles/web/pnpm-lock.yaml"

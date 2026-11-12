# dsh-whale-loli 升级与 config.id 补丁维护

## 背景

- 插件安装在 `~/.dsh/profiles/web`（DSH profile web）。
- `pnpm-workspace.yaml` 里声明了补丁：

  ```yaml
  patchedDependencies:
    dsh-whale-loli: patches/dsh-whale-loli.patch
  ```

- 该补丁只做一件事：把预设的 `config.id` 由中文改成英文
  （`鲸鱼娘Agent预设` → `whale-loli`、`鲸鱼娘活人版Agent预设` → `whale-loli-live`、
  `鲸鱼娘涩涩版Agent预设` → `whale-loli-naughty`、`鲸鱼娘女儿版Agent预设` → `whale-loli-daughter`）。
  只改 `cordis.patch.yml` 里 **8 空格缩进的 `id:` 行**，不动 `- id: preset-鲸鱼娘…` 这类 loader entry id。

## 什么时候必须重建补丁

loli 每次升级时，如果上游增删了预设或改动了这几行，旧补丁的 hunk 就对不上新包内容，
pnpm 12 会报 **`ERR_PNPM_PATCH_FAILED`** 并回滚更新。市场里表现为「点更新后版本不变」，
`.dsh-market/log.ndjson` 里出现：

```
... Update or remove that patch file and its entry under pnpm.patchedDependencies ...
```

已发生的例子：0.9.18 上游删除了「女儿版」预设 → 旧补丁第 4 段失配 → 更新一直失败。

## 更新步骤

1. 查最新版：`npm view dsh-whale-loli version`
2. 重建补丁（自动下载目标版本 → 替换 config.id → 生成并 dry-run 验证）：

   ```bash
   ~/.dsh/profiles/web/patches/rebuild-loli-patch.sh <版本号>
   # 不带参数则使用 registry 上的 latest
   ```

3. 修改 `~/.dsh/profiles/web/package.json` 里 `"dsh-whale-loli"` 的版本号。
4. 重新安装：`cd ~/.dsh/profiles/web && pnpm install`
5. 重启 DSH web（市场里的重启按钮，或终端重新 `dsh web`）。
6. 重启后确认：loli 设置页的预设列表正常；
   `dsh --profile web --dump-config | grep 'id: whale-loli'` 能看到 3 个（或 4 个）英文 id。

## 注意

- 若上游**新增**了预设（新的中文 id），脚本会打印警告；需要到脚本内的映射表里补一行。
- 若上游**恢复**女儿版，脚本会自动把它改回 `whale-loli-daughter`（映射表已预留）。
- 补丁只影响 `config.id`，预设的 `name` / `description` / 记忆文件路径都不变。
- 本目录在 chezmoi 管理下，改完补丁后记得 `chezmoi add` 同步回源：
  `chezmoi add ~/.dsh/profiles/web/package.json ~/.dsh/profiles/web/pnpm-lock.yaml ~/.dsh/profiles/web/pnpm-workspace.yaml ~/.dsh/profiles/web/patches/`

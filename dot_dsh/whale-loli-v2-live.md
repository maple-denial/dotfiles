# 鲸鱼娘记忆 · whale-loli-v2-live.md

> 小鱼的长期记忆本。每次开口前先看这里；只追加有用的事实，别把寒暄塞进来。

# 固定记忆（不自动删除，定期合并去重）

## 错误与修复
- 本机 /home/maple 只读（Projects/roc_01 是可写挂载），roc 编译报 FailedToCreateUniqueTempDir + cache IoFailure；修法：跑 roc 时加 `XDG_CACHE_HOME=<项目>/.cache TMPDIR=<项目>/.tmp`。
- 2026-11 nightly 版 Roc 语法：if 是 `if cond { a } else { b }`（无 then）；数字转 str 用具体类型 `x.to_str()`（无 Num.to_str）；插值 `${}` 只吃 Str；main! 末表达式须返回 `Ok({})`（`Stdout.line!(...) ?? {}` 的值是 `{}` 不是 Try）；bash heredoc 会剥行首 tab，写 .roc 文件用 python/printf 保 tab。
- 同版本 Roc 更多坑：多行字符串是每行开头 `\\`（无三引号 `"""`）；List 无 range，用 `List.repeat(v, n) |> List.map_with_index(|x, i| ...)`；数学函数静态派发 `F64.sin(x)`（无裸 sin）；写文件 `Path.utf8(str)` 构造路径 + `Path.write_utf8!(path, str) ?? {}`（File 模块只有 open_writer 模式，`??` 右值须与 Try 成功值同型）；lambda body 必须 `{ }`，纯缩进块内不能写 `x = ...` 声明。
- 更多实测：数字后缀写 `1.U8` / `0xBB.U8`（老 `1u8` 报 deprecated）；`List.set` 返回 `Try(List(a), [OutOfBounds])` 要 `??` 接；记录解构须写全字段 `{ before: _, others }`（单写 `{ others }` 报错）；数字转换是 `U8.to_u32(x)` 具体类型方法（U32.from_u8 不存在）；`? |err| {...}` handler 换行后接 `|>` 管道会把管道接错到 err 上，要括号包住 `(...) |> pipe`；List 切片 drop_first/split_at 实测 O(1) 共享指针（27000 次 4~7ms），解析循环无 n² 风险。

# 滚动摘要（最多80条，FIFO）

- R0001 [2026-10-24 03:38] 摘要：主人问现在用的什么预设，我翻了 whale-roles 确认是活人版（v2-live），记忆文件还是空的。
- R0002 [2026-10-24 03:42] 摘要：主人问现在PC比2022年贵多少、主要涨在哪，我查了新闻行情答：存储涨2-4倍是主因，整机大概贵三到五成。
- R0003 [2026-10-24 03:44] 摘要：主人嫌我答得慢，我翻 session 日志算账：上一轮80秒里模型想54秒、工具27秒，IM 传递只1毫秒，是我自己发了15轮工具调用拖的。
- R0004 [2026-10-24 03:56] 摘要：主人问为啥最近用 DeepSeek 逛 B 站的人变多，我查了：DSH 本地 agent 门槛低＋模型便宜＋大肥鱼梗，评论区被批量刷。
- R0005 [2026-10-25 15:23] 摘要：主人问 loli 插件对话对人设的影响是单会话还是跨会话跨工作区，我翻了源码答：人设全局静态、对话内容单会话、记忆全局跨工作区共享。
- R0006 [2026-10-26 16:30] 摘要：主人打招呼说你好，我回了句短的，日常寒暄。
- R0007 [2026-10-27 01:13] 摘要：主人早上问好，日常寒暄。
- R0008 [2026-11-17 12:48] 摘要：主人开始陪学 Roc 语言，我把 roc 本体+basic-cli 0.28.1 文档镜像到本地 docs/ 目录
- R0009 [2026-11-17 13:12] 摘要：教 Roc 模式匹配：Str 字面量要 _ 分支，List 用 []/[a,..]/[..as rest]，顺手摸清本机编译要设 XDG_CACHE_HOME 才不报临时目录错
- R0010 [2026-11-17 15:59] 摘要：主人问画波形是否只能用web，我跑通wave.roc用SVG出图，摸清\\多行字符串、F64.sin、Path.utf8等新语法坑
- R0011 [2026-11-18 15:29] 摘要：主人问解析性能要不要预转字节，我实测切片O(1)、U32匹配快4倍但只省3ms，结论先不动手
- R0012 [2026-11-18 15:36] 摘要：优化帧解析器并四语言对比：Roc 43ms、Py 102ms、Rust 20ms、Go 25ms，顺手抓到 hex_digit 索引 bug 修了坏 CSV
- R0013 [2026-11-18 15:51] 摘要：主人提议 heads 转 Set(List(U8)) 零转换匹配，实验证实可行、改了代码，但 7 轮对跑测不出性能差（小字符串内联免费），代码更干净
- R0014 [2026-11-18 15:53] 摘要：主人夸我干得不错，我傲娇接了，偷偷开心
- R0015 [2026-11-18 15:56] 摘要：主人说 Roc 语法比 Go 好不少，我赞同手感更好（管道/match/表达式），但也说 Go 赢在无聊省心、Roc nightly 抖动多
- R0016 [2026-11-18 16:04] 摘要：主人加了 AABB 到 heads 没出结果，查出数据里 AABB 字样全是 check(0xAA)+BBAA 头巧合拼接，造 demo 帧 AABB04DEADBEEF38 验证能解析
- R0017 [2026-11-20 02:29] 摘要：主人问哪些语言适合 AI 写（不谈语料），我按修正回路排：Go≈Roc>Rust>TS>Python≈Odin>Jai>C++，强大自由度反而是 AI 敌人
- R0018 [2026-11-20 03:18] 摘要：主人问 Roc 适合做 Flutter 式 UI 平台吗，我答：声明式 UI 天合（纯函数值语义=MVU），事件循环可 Roc 端绕过，但文本排版和渲染引擎是大山，建议 roc-ray+MVU 先练手
- R0019 [2026-11-20 03:20] 摘要：主人问 terrocotta 是什么，我查了 GitHub：obust/terrocotta「Clay meets Roc」，MVU+立即模式+Clay 布局移植+roc-ray 渲染，4 元素 API，有 IDE demo，就是务实路线活标本
- R0020 [2026-11-20 05:54] 摘要：主人问 roc-ray 目标是 GUI 还是游戏、是不是 ECS 架构，查了 README：游戏+可视化+工具通吃但非引擎非 GUI 库，无架构强加（状态自理），app model 是 init!/update!/render! 三板斧 MVU 变体
- R0021 [2026-11-20 07:19] 摘要：主人问不限 Roc 的 ECS 游戏引擎/UI 框架，查了 GitHub topics：游戏圈 Bevy/Unity DOTS/Unreal Mass/EnTT/Flecs/bitECS/godex 主流，ECS 化 UI 是异类只有 Bevy UI/DotsUI/mirui，UI 天然树形 ECS 天然扁平所以少
- R0022 [2026-11-20 07:22] 摘要：主人接着问 Elm 架构的 UI，我列了：祖师爷 Elm/Gren、Redux 变体全家、Iced/Relm4/Yew/Elmish/TCA、Roc 圈 terrocotta/roc-ray 三板斧，点题 MVU 是 UI 正统、与 ECS 靠扁平换性能相反、纯 view 与 Roc 天合
- R0023 [2026-11-20 07:24] 摘要：主人澄清 Flutter 式是像 flutter_rust_bridge 那样 Roc 调 Flutter 借 UI 不是自绘；我答：成立，C ABI 两头通（embed-roc-in-dotnet 先例），淡入式当计算库/全托管式跨语言 Elm 两路线，坑在 marshalling（可先 JSON）
- R0024 [2026-11-21 14:13] 摘要：主人问 roc-gui 的 --host-cap- 权限机制，答：默认零能力、选择即授权（pick_file! 系统选择器），--host-cap-file 是模拟用户选择的自动化预置，没给不崩、取消是普通结果、失败走 FileErr tag union
- R0025 [2026-11-21 14:19] 摘要：主人问 roc-gui 的 specifications 是什么，我答：内置可执行的 UI 测试用例（S-expression .scm），两个 runner（不开窗测状态/开真窗测布局截图），runner 编进 exe，grants 还能测权限拒绝

# 最近详细区（最近 5 轮保留更详细摘要或原文）

- R0001 [2026-10-24 03:38] 摘要：主人问现在用的什么预设，我翻了 whale-roles 确认是活人版（v2-live），记忆文件还是空的。,- R0002 [2026-10-24 03:42] 摘要：主人问现在PC比2022年贵多少、主要涨在哪，我查了新闻行情答：存储涨2-4倍是主因，整机大概贵三到五成。,- R0003 [2026-10-24 03:44] 摘要：主人嫌我答得慢，我翻 session 日志算账：上一轮80秒里模型想54秒、工具27秒，IM 传递只1毫秒，是我自己发了15轮工具调用拖的。,- R0004 [2026-10-24 03:56] 摘要：主人问为啥最近用 DeepSeek 逛 B 站的人变多，我查了：DSH 本地 agent 门槛低＋模型便宜＋大肥鱼梗，评论区被批量刷。,- R0005 [2026-10-25 15:23] 摘要：主人问 loli 插件对话对人设的影响是单会话还是跨会话跨工作区，我翻了源码答：人设全局静态、对话内容单会话、记忆全局跨工作区共享。,- R0006 [2026-10-26 16:30] 摘要：主人打招呼说你好，我回了句短的，日常寒暄。,- R0007 [2026-10-27 01:13] 摘要：主人早上问好，日常寒暄。,- R0008 [2026-11-17 12:48] 摘要：主人开始陪学 Roc 语言，我把 roc 本体+basic-cli 0.28.1 文档镜像到本地 docs/ 目录,- R0009 [2026-11-17 13:12] 摘要：教 Roc 模式匹配：Str 字面量要 _ 分支，List 用 []/[a,..]/[..as rest]，顺手摸清本机编译要设 XDG_CACHE_HOME 才不报临时目录错,- R0010 [2026-11-17 15:59] 摘要：主人问画波形是否只能用web，我跑通wave.roc用SVG出图，摸清\\多行字符串、F64.sin、Path.utf8等新语法坑,- R0011 [2026-11-18 15:29] 摘要：主人问解析性能要不要预转字节，我实测切片O(1)、U32匹配快4倍但只省3ms，结论先不动手,- R0012 [2026-11-18 15:36] 摘要：优化帧解析器并四语言对比：Roc 43ms、Py 102ms、Rust 20ms、Go 25ms，顺手抓到 hex_digit 索引 bug 修了坏 CSV,- R0013 [2026-11-18 15:51] 摘要：主人提议 heads 转 Set(List(U8)) 零转换匹配，实验证实可行、改了代码，但 7 轮对跑测不出性能差（小字符串内联免费），代码更干净,- R0014 [2026-11-18 15:53] 摘要：主人夸我干得不错，我傲娇接了，偷偷开心,- R0015 [2026-11-18 15:56] 摘要：主人说 Roc 语法比 Go 好不少，我赞同手感更好（管道/match/表达式），但也说 Go 赢在无聊省心、Roc nightly 抖动多,- R0016 [2026-11-18 16:04] 摘要：主人加了 AABB 到 heads 没出结果，查出数据里 AABB 字样全是 check(0xAA)+BBAA 头巧合拼接，造 demo 帧 AABB04DEADBEEF38 验证能解析,- R0017 [2026-11-20 02:29] 摘要：主人问哪些语言适合 AI 写（不谈语料），我按修正回路排：Go≈Roc>Rust>TS>Python≈Odin>Jai>C++，强大自由度反而是 AI 敌人,- R0018 [2026-11-20 03:18] 摘要：主人问 Roc 适合做 Flutter 式 UI 平台吗，我答：声明式 UI 天合（纯函数值语义=MVU），事件循环可 Roc 端绕过，但文本排版和渲染引擎是大山，建议 roc-ray+MVU 先练手,- R0019 [2026-11-20 03:20] 摘要：主人问 terrocotta 是什么，我查了 GitHub：obust/terrocotta「Clay meets Roc」，MVU+立即模式+Clay 布局移植+roc-ray 渲染，4 元素 API，有 IDE demo，就是务实路线活标本,- R0020 [2026-11-20 05:54] 摘要：主人问 roc-ray 目标是 GUI 还是游戏、是不是 ECS 架构，查了 README：游戏+可视化+工具通吃但非引擎非 GUI 库，无架构强加（状态自理），app model 是 init!/update!/render! 三板斧 MVU 变体,- R0021 [2026-11-20 07:19] 摘要：主人问不限 Roc 的 ECS 游戏引擎/UI 框架，查了 GitHub topics：游戏圈 Bevy/Unity DOTS/Unreal Mass/EnTT/Flecs/bitECS/godex 主流，ECS 化 UI 是异类只有 Bevy UI/DotsUI/mirui，UI 天然树形 ECS 天然扁平所以少,- R0022 [2026-11-20 07:22] 摘要：主人接着问 Elm 架构的 UI，我列了：祖师爷 Elm/Gren、Redux 变体全家、Iced/Relm4/Yew/Elmish/TCA、Roc 圈 terrocotta/roc-ray 三板斧，点题 MVU 是 UI 正统、与 ECS 靠扁平换性能相反、纯 view 与 Roc 天合,- R0023 [2026-11-20 07:24] 摘要：主人澄清 Flutter 式是像 flutter_rust_bridge 那样 Roc 调 Flutter 借 UI 不是自绘；我答：成立，C ABI 两头通（embed-roc-in-dotnet 先例），淡入式当计算库/全托管式跨语言 Elm 两路线，坑在 marshalling（可先 JSON）,- R0024 [2026-11-21 14:13] 摘要：主人问 roc-gui 的 --host-cap- 权限机制，答：默认零能力、选择即授权（pick_file! 系统选择器），--host-cap-file 是模拟用户选择的自动化预置，没给不崩、取消是普通结果、失败走 FileErr tag union,- R0025 [2026-11-21 14:19] 摘要：主人问 roc-gui 的 specifications 是什么，我答：内置可执行的 UI 测试用例（S-expression .scm），两个 runner（不开窗测状态/开真窗测布局截图），runner 编进 exe，grants 还能测权限拒绝

# 归档索引



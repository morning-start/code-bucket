# Code Bucket for Scoop

这是一个专为开发者设计的[Scoop](https://scoop.sh/)仓库，预配置了各种开发工具和运行环境。所有设置都开箱即用，无需手动配置。

## ✅ 支持的工具

| 工具                 | 描述                                                                 |
| -------------------- | --------------------------------------------------------------------------- |
| **agy**              | Antigravity CLI - AI agent runtime manager                                    |
| **aichat**           | 强大的 ChatGPT 命令行工具。                                                    |
| **android-studio**   | 官方 Android 开发 IDE。                                                       |
| **atomcode**         | 开源的终端 AI 编码 Agent（Claude Code / Cursor Agent 替代品）。                  |
| **bun**              | 极速的 JavaScript 运行时、打包器、转译器和包管理器。                             |
| **claude-code**      | Anthropic 推出的 Agentic 编码助手，在终端中编写、调试并探索代码库。              |
| **codex-cli**        | OpenAI Codex CLI - 终端中的 AI 编码助手。                                       |
| **codux**            | 面向 React 的可视化 IDE，内置 AI 编码 Agent。                                  |
| **DbPaw**            | 连接 PostgreSQL/MySQL/SQLite/SQL Server/ClickHouse 的桌面 SQL 客户端。         |
| **dbx**              | 开源轻量级跨平台数据库客户端，支持 MySQL/PostgreSQL/SQLite/Redis/MongoDB 等。    |
| **deno**             | 安全的 JavaScript 和 TypeScript 运行时。                                        |
| **dory**             | 面向人类与 Agent 的 AI 原生 SQL 客户端。                                         |
| **flutter-gradle-tool** | 通过管理 Gradle wrapper 与 Maven 镜像加速 Flutter Android 构建的 CLI。       |
| **gdem**             | 基于 GodotHub 的 Godot 引擎版本管理工具。                                        |
| **git-tags**         | Git 标签管理器。                                                              |
| **jcode**            | 快速、安全、智能的代码片段管理器。                                              |
| **kilocode**         | 一体化的 Agentic 工程平台，借助 AI 编码 Agent 更快构建、交付、迭代。              |
| **lazygit**          | 简单的 Git 命令终端 UI。                                                       |
| **link-disk**        | 通过硬链接/软链接将软件配置与数据从 C 盘转移到其他分区。                           |
| **miniconda3**       | Python 包管理器 (Miniconda)。                                                 |
| **miniforge**        | 专为 conda-forge 设计的最小 conda 发行版。                                       |
| **miniforge-cn**     | conda-forge 发行版（国内镜像）。                                               |
| **mimocode**         | MiMo Code：终端原生 AI 编码助手，具备持久化记忆。                                |
| **mise**             | 多语言工具版本管理器与任务运行器。                                              |
| **moonbit**          | MoonBit 语言的官方 CLI 工具链（moon 编译器、构建系统、包管理器及 MoonPilot）。     |
| **nub**              | 增强而非取代 Node.js 的一体化快速工具集。                                         |
| **omp**              | 终端 AI 编码 Agent，支持会话、子 Agent、斜杠命令与扩展。                          |
| **opencode**         | 开源的 AI 编码 Agent。                                                         |
| **openfang**         | OpenFang - 开源的 AI 助手。                                                    |
| **orca**             | 最强大的 Agent 开发环境（ADE），可并排运行 Claude Code、Codex、OpenCode 等。      |
| **oxideterm**        | 面向开发者的现代终端模拟器。                                                    |
| **reasonix**         | DeepSeek 原生的终端 AI 编码 Agent，围绕前缀缓存稳定性构建。                       |
| **rmux**             | 具备 tmux 风格 CLI、守护进程与原生 Windows 支持的终端复用器。                      |
| **rustup**           | Rust 多版本管理器。                                                           |
| **rustup-gnu**       | Rust 多版本管理器（GCC 工具链）。                                               |
| **shell360**         | 跨平台 SSH 与 SFTP 客户端。                                                    |
| **terax-ai**         | 轻量级（7MB）终端优先的 AI 原生开发工作区（Tauri 2 + Rust + React 19）。          |
| **uv**               | 极速的 Python 安装器与依赖解析器，使用 Rust 编写。                                |

## 🛠 配置亮点

所有工具均已配置为：

* 自动将二进制文件添加到`PATH`
* 将持久化数据存储在`scoop/persist`目录中
* 在安装后应用常见配置（如注册表设置、镜像源等）

## 🧪 使用说明

将此仓库添加到Scoop：

```powershell
scoop bucket add code https://github.com/morning-start/code-bucket.git
scoop bucket add code https://gitee.com/morning-start/code-bucket.git
```

## 📄 许可证

MIT / Apache-2.0 / BSD 等。详情请参见各个工具的许可证。

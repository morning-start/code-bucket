# Code Bucket for Scoop

这是一个专为程序员设计的 [Scoop](https://scoop.sh/) bucket 库，包含多个常用开发工具和语言运行时，并已配置好默认路径、缓存、持久化等设置，开箱即用。

## ✅ 支持的工具列表

| 工具                 | 描述                                                 |
| -------------------- | ---------------------------------------------------- |
| **bun**        | 极快的 JavaScript 运行时、打包器、转译器和包管理器。 |
| **fnm**        | 跨平台 Node.js 版本切换工具。                        |
| **fvm**        | Flutter SDK 多版本管理工具。                         |
| **git**        | 分布式版本控制系统（Git for Windows）。              |
| **gradle**     | 开源构建自动化工具。                                 |
| **gvm**        | Go 语言多版本管理器。                                |
| **jabba**      | Java 版本管理器。                                    |
| **maven**      | Java 项目管理工具。                                  |
| **miniconda3** | Python 包管理器（Miniconda）。                       |
| **pnpm**       | 快速且节省磁盘空间的 Node.js 包管理器。              |
| **rustup**     | Rust 多版本管理器。                                  |
| **uv**         | 极快的 Python 安装与依赖解析工具。                   |
| **yarn**       | Node.js 包管理器。                                   |

## 🛠 配置说明

所有工具均已预设以下行为：

* 环境变量自动添加到 `PATH`
* 缓存/数据存储路径指向 `scoop/persist` 目录
* 默认配置项已在安装后自动执行（如 Git 的注册表配置、Yarn 的镜像源设置等）

## 🧪 使用方式

1. 添加此 bucket 到 Scoop：
   ```powershell
   scoop bucket add code https://github.com/yourname/code-bucket.git
   ```
2. 安装任意工具：
   ```powershell
   scoop search code/<app_name>
   scoop install code/<app_name>
   ```

## 📄 License

MIT / Apache-2.0 / BSD 等，请参考各工具具体许可协议。

# Code Bucket for Scoop

这是一个专为开发者设计的[Scoop](https://scoop.sh/)仓库，预配置了各种开发工具和运行环境。所有设置都开箱即用，无需手动配置。

## ✅ 支持的工具

| 工具                 | 描述                                                                 |
| -------------------- | --------------------------------------------------------------------------- |
| **aichat**           | 强大的ChatGPT命令行工具。                                                     |
| **android-studio**   | 官方Android开发IDE。                                                         |
| **bun**              | 极速的JavaScript运行时、打包器、转译器和包管理器。                                  |
| **codebuddy**        | AI驱动的IDE，让编程更愉快高效。                                                  |
| **deno**             | 安全的JavaScript和TypeScript运行时。                                              |
| **fnm**              | 跨平台Node.js版本切换工具。                                                    |
| **fvm**              | Flutter SDK版本管理工具。                                                      |
| **git**              | 分布式版本控制系统(Git for Windows)。                                           |
| **git-tags**         | Git标签管理器。                                                                |
| **gdem**             | 基于GodotHub的Godot引擎版本管理工具。                                             |
| **gradle**           | 开源构建自动化工具。                                                           |
| **gvm**              | Golang版本管理工具。                                                           |
| **img2ico**          | 将图片(png/jpg)转换为ico文件的免费工具。                                          |
| **jabba**            | Java版本管理工具。                                                             |
| **jvm**              | Java-Mocha Java版本管理工具。                                                  |
| **jvms**             | Windows平台JDK版本管理工具。                                                   |
| **maven**            | Java项目管理工具。                                                             |
| **miniconda3**       | Python包管理器(Miniconda)。                                                    |
| **miniforge**        | 专为conda-forge设计的最小conda发行版。                                           |
| **miniforge-cn**     | conda-forge发行版。                                                           |
| **pnpm**             | 快速且节省磁盘空间的Node.js包管理器。                                             |
| **poetry**           | Python依赖管理工具。                                                           |
| **qoder**            | 面向真实软件的智能编码平台。                                                     |
| **rig**              | R语言安装管理器：安装、删除、配置R版本。                                           |
| **rustup**           | Rust多版本管理器。                                                             |
| **rustup-gnu**       | Rust多版本管理器(GCC工具链)。                                                   |
| **shell360**         | 跨平台SSH和SFTP客户端。                                                       |
| **trae-cn**          | AI驱动的IDE，让编程更愉快高效。                                                  |
| **uv**               | 极速的Python安装器和依赖解析器，使用Rust编写。                                      |
| **version-manager**  | 支持60+ SDK的通用版本管理器，界面灵感来自lazygit。                                  |
| **vfox**             | 使用单一CLI工具管理多个SDK版本，可通过插件扩展。                                     |
| **visx**             | VS Code扩展下载器。                                                            |
| **vscode**           | 轻量但功能强大的源代码编辑器。                                                    |
| **yarn**             | Node.js依赖管理器。                                                            |
| **zed**              | 高性能多人代码编辑器，由Atom创作者开发。                                            |

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

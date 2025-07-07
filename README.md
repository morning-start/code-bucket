# Code Bucket for Scoop

This is a [Scoop](https://scoop.sh/) bucket specially designed for developers, pre-configured with various development tools and runtime environments. All settings are ready out of the box, no manual configuration needed.

## ✅ Supported Tools

| Tool                 | Description                                                                 |
| -------------------- | --------------------------------------------------------------------------- |
| **bun**              | Extremely fast JavaScript runtime, bundler, transpiler and package manager. |
| **fnm**              | Cross-platform Node.js version switcher.                                    |
| **fvm**              | Flutter SDK version manager.                                                |
| **git**              | Distributed version control system (Git for Windows).                       |
| **gradle**           | Open-source build automation tool.                                          |
| **gvm**              | Golang version manager.                                                     |
| **jabba**            | Java version manager.                                                       |
| **jvms**             | JDK Version Manager (JVMS) for Windows.                                     |
| **maven**            | Java project management tool.                                               |
| **miniconda3**       | Python package manager (Miniconda).                                         |
| **pnpm**             | Fast and disk-efficient Node.js package manager.                            |
| **rig**              | R installation manager: Install, remove, configure R versions.              |
| **rustup**           | Rust multi-version manager.                                                 |
| **uv**               | Blazing-fast Python installer and dependency resolver.                      |
| **yarn**             | Node.js package manager.                                                    |
| **version-manager**  | A general version manager for 60+ SDKs.                                     |
| **vfox**             | Manage multiple SDK versions with a single CLI tool.                        |

## 🛠 Configuration Highlights

All tools have been configured to:

* Automatically add binaries to `PATH`
* Store persistent data in `scoop/persist` directory
* Apply common configurations during post-installation (e.g., registry settings, mirror sources)

## 🧪 Usage Instructions

1. Add this bucket to Scoop:
    ```powershell
   scoop bucket add code https://github.com/yourname/code-bucket.git
   ```
2. Install any application:
    ```powershell
   scoop search code/<app_name>
   scoop install code/<app_name>
   ```

## 📄 License

MIT / Apache-2.0 / BSD etc. Please refer to individual tool licenses for details.

---

您可以将上述内容保存为 [README.md](javascript:void(0)) 文件并提交至仓库根目录，以便用户快速了解和使用您的 Scoop bucket。如果需要加入更多定制信息（如贡献指南、CI 状态、图标等），也可以进一步扩展。

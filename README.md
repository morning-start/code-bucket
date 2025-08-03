# Code Bucket for Scoop

This is a [Scoop](https://scoop.sh/) bucket specially designed for developers, pre-configured with various development tools and runtime environments. All settings are ready out of the box, no manual configuration needed.

## ✅ Supported Tools

| Tool                 | Description                                                                 |
| -------------------- | --------------------------------------------------------------------------- |
| **aichat**           | A powerful chatgpt cli.                                                     |
| **android-studio**   | The official IDE for Android development.                                   |
| **bun**              | Extremely fast JavaScript runtime, bundler, transpiler and package manager. |
| **codebuddy**        | An AI-powered IDE that makes programming more enjoyable and efficient.      |
| **fnm**              | Cross-platform Node.js version switcher.                                    |
| **fvm**              | Flutter SDK version manager.                                                |
| **git**              | Distributed version control system (Git for Windows).                       |
| **git-tags**         | Git tag manager.                                                            |
| **gradle**           | Open-source build automation tool.                                          |
| **gvm**              | Golang version manager.                                                     |
| **img2ico**          | A freeware to convert image(png/jpg) to ico file.                           |
| **jabba**            | Java version manager.                                                       |
| **jvm**              | Java-Mocha is a Java version management tool.                               |
| **jvms**             | JDK Version Manager (JVMS) for Windows.                                     |
| **maven**            | Java project management tool.                                               |
| **miniconda3**       | Python package manager (Miniconda).                                         |
| **pnpm**             | Fast and disk-efficient Node.js package manager.                            |
| **poetry**           | Dependency Management for Python.                                           |
| **rig**              | R installation manager: Install, remove, configure R versions.              |
| **rustup**           | Manage multiple rust installations with ease.                               |
| **rustup-gnu**       | Manage multiple rust installations with ease (GCC toolchain).               |
| **trae-cn**          | An AI-powered IDE that makes programming more enjoyable and efficient.      |
| **uv**               | An extremely fast Python package installer and resolver, written in Rust.   |
| **version-manager**  | A general version manager for 60+ SDKs with TUI inspired by lazygit.        |
| **vfox**             | Manage multiple SDK versions with a single CLI tool, extendable via plugins.|
| **visx**             | The vscode extension downloader.                                            |
| **vscode**           | Lightweight but powerful source code editor.                                |
| **yarn**             | Node.js dependency manager.                                                 |

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
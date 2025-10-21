# Code Bucket for Scoop

This is a [Scoop](https://scoop.sh/) bucket specially designed for developers, pre-configured with various development tools and runtime environments. All settings are ready out of the box, no manual configuration needed.

## ✅ Supported Tools

| Tool                 | Description                                                                 |
| -------------------- | --------------------------------------------------------------------------- |
| **aichat**           | A powerful chatgpt cli.                                                     |
| **android-studio**   | The official IDE for Android development.                                   |
| **bun**              | Extremely fast JavaScript runtime, bundler, transpiler and package manager. |
| **codebuddy**        | An AI-powered IDE that makes programming more enjoyable and efficient.      |
| **deno**             | A secure runtime for JavaScript and TypeScript                              |
| **fnm**              | Cross-platform Node.js version switcher.                                    |
| **fvm**              | Flutter SDK version manager.                                                |
| **git**              | Distributed version control system (Git for Windows).                       |
| **git-tags**         | Git tag manager.                                                            |
| **gdem**             | A Godot engine version management tool based on GodotHub.                   |
| **gradle**           | Open-source build automation tool.                                          |
| **gvm**              | Golang version manager.                                                     |
| **img2ico**          | A freeware to convert image(png/jpg) to ico file.                           |
| **jvm**              | Java-Mocha is a Java version management tool.                               |
| **maven**            | Java project management tool.                                               |
| **miniconda3**       | Python package manager (Miniconda).                                         |
| **miniforge**        | A minimal conda distribution specific to conda-forge.                       |
| **miniforge-cn**     | A conda-forge distribution                                                  |
| **pnpm**             | Fast and disk-efficient Node.js package manager.                            |
| **poetry**           | Dependency Management for Python.                                           |
| **qoder**            | Agentic Coding Platform for Real Software                                   |
| **rig**              | R installation manager: Install, remove, configure R versions.              |
| **rustup**           | Manage multiple rust installations with ease.                               |
| **rustup-gnu**       | Manage multiple rust installations with ease (GCC toolchain).               |
| **shell360**         | Cross-platform SSH & SFTP client                                            |
| **trae-cn**          | An AI-powered IDE that makes programming more enjoyable and efficient.      |
| **uv**               | An extremely fast Python package installer and resolver, written in Rust.   |
| **version-manager**  | A general version manager for 60+ SDKs with TUI inspired by lazygit.        |
| **vfox**             | Manage multiple SDK versions with a single CLI tool, extendable via plugins.|
| **visx**             | The vscode extension downloader.                                            |
| **vscode**           | Lightweight but powerful source code editor.                                |
| **yarn**             | Node.js dependency manager.                                                 |
| **zed**              | High-performance, multiplayer code editor from the creators of Atom.        |

## 🛠 Configuration Highlights

All tools have been configured to:

* Automatically add binaries to `PATH`
* Store persistent data in `scoop/persist` directory
* Apply common configurations during post-installation (e.g., registry settings, mirror sources)

## 🧪 Usage Instructions

1. Add this bucket to Scoop:
    ```powershell
   scoop bucket add code https://github.com/yourname/code-bucket.git

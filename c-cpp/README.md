# 1.VSCode 配置

如果使用的是 VSCode，若出现 VSCode 编辑器中的 clangd 无法找到标准库的情况，可能需要在 `.vscode/settings,json` 中添加下面的内容：

```json
{
    "clangd.arguments": [
        "--query-driver=/nix/store/**-clang-**/bin/clang++",
        "--compile-commands-dir=build",
        "--background-index",
        "--log=verbose"
    ],
    "clangd.path": "clangd",
}
```

---

# 2.添加依赖库

> 这里以 OpenCV 为例。

在这里添加库：

```nix
# 运行时依赖库 
buildInputs = with pkgs; [
    # 示例：添加常用库
    llvmPackages.openmp
    eigen
    boost
    nlohmann_json
    fmt
];
```

一般像这样直接添加 **库名称** 即可。但是有时候依赖库的一些选项需要你手动开启，比如 OpenCV 的 GUI 后端支持（（需要链接 GTK、Qt 或 Cocoa））：

```nix
buildInputs = with pkgs; [
  # ... 其他库
  (opencv.override {
    enableGtk3 = true;   # 开启 GTK3 支持，解决 imshow 问题
    enableFfmpeg = true; # 开启视频读取支持
  })
];
```

- **定义阶段**: 维护者写了一个函数，默认把 `enableGtk3` 设为 `false`。
- **实例化阶段**: 当你直接用 `pkgs.opencv` 时，Nix 用默认值运行这个函数。
- **Override 阶段**: 当你写 `.override { enableGtk3 = true; }` 时，你实际上是把这个函数拿过来，把对应的参数改掉，让 Nix 重新计算出一个新的“构建方案”。

> 库名称在 [NixOS Packages Search](https://search.nixos.org/packages) 中搜索。但是在 `search.nixos.org` 上，你看到的是编译好的**软件包结果**，而要找到这些 `.override` 选项，你需要查看这个包的**源代码（定义文件）**。以下是寻找这些“隐藏选项”的三种方法。

## 2.1 方法一：查看 Nixpkgs 源代码 

在 Nixpkgs 中，每个包本质上都是一个 Nix 函数。这个函数的开头部分定义了它接受的所有参数。

1. 打开 GitHub 上的 [Nixpkgs 仓库](https://github.com/NixOS/nixpkgs)。
2. 路径规律通常是：`pkgs/development/libraries/opencv/default.nix`。
3. 你会看到类似这样的代码：

```nix
{ lib, stdenv, fetchFromGitHub, cmake
, enableGtk3 ? false    # <--- 这就是选项
, enableFfmpeg ? false  # <--- 还有这里
, enablePython ? false
, ...
}:
```

这些带有 `? false` 或 `? true` 的变量，就是你可以通过 `.override` 修改的**开关**。

> 也可以在 [NixOS Packages Search](https://search.nixos.org/packages) 中搜索包时，点击 `Source` 跳转到构建源码。

## 2.2 方法二：使用 `nix repl` 

可以直接在命令行里询问 Nix：

1. 在终端输入 `nix repl -f "<nixpkgs>"`。
2. 输入包名并查看它的 `override` 参数（利用 Tab 补全）：

```bash
nix-repl> opencv.override.__functionArgs
{ enableGtk3 = true; enableFfmpeg = true; ... }
```

`__functionArgs` 会列出该函数所有可以被覆盖的参数。如果值为 `true`，表示这个参数是可选的（你可以 override 它）。

## 2.3 方法三：经验

在 Nixpkgs 中，有一套不成文的命名规范，熟悉了之后你可以“盲猜”出很多选项：

- **GUI 支持**: 通常叫 `enableGtk2`, `enableGtk3`, `enableQt5`, `withQt`。
- **多媒体**: 通常叫 `enableFfmpeg`, `withAlsa`, `withX11`。
- **语言绑定**: 通常叫 `enablePython`, `withJava`。

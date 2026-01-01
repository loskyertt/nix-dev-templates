# 1.使用方法

1. 先启用 flakes 功能

2. 创建 c-cpp 模板示例：

```bash
nix flake init -t github:loskyertt/nix-dev-templates#c-cpp
```

>> `#` 后跟的是对应开发环境模板名称。Nix 会为了缓存速度缓存 GitHub 上的 Flake。如果有时候创建模板失败，可以通过添加 `--refresh` 参数来强制它重新检查远程仓库：

```bash
nix flake init -t github:loskyertt/nix-dev-templates#c-cpp --refresh
```

3. 启动开发环境

执行 `nix develop` 打开 Nix-defined shell。如果使用的是 VSCode，在 Nix-defined shell 执行 `code .` 打开 VSCode 即可，VSCode 会继承 shell 中的环境。
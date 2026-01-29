# 1.使用方法

## 1.1 通过集成终端

> 该方式适合用于本地开发（本地主机或者 WSL2）。

1. 先启用 flakes 功能

2. 创建 c-cpp 模板示例：

```bash
nix flake init -t github:loskyertt/nix-dev-templates#c-cpp
```

> `#` 后跟的是对应开发环境模板名称。Nix 会为了缓存速度缓存 GitHub 上的 Flake。

如果有时候创建模板失败，可以通过添加 `--refresh` 参数来强制它重新检查远程仓库：

```bash
nix flake init -t github:loskyertt/nix-dev-templates#c-cpp --refresh
```

有时候可能会遇到这种问题：

```bash
~/Dev/node_dev
❯ nix flake init -t github:loskyertt/nix-dev-templates#node-js
zsh: no matches found: github:loskyertt/nix-dev-templates#node-js
```

`#` 可能与 shell 中的 `#` 冲突，可以通过加双引号或者 `\` 转义来解决：

```bash
nix flake init -t "github:loskyertt/nix-dev-templates#c-cpp"

# 或者
nix flake init -t github:loskyertt/nix-dev-templates\#c-cpp
```

3. 启动开发环境

执行 `nix develop` 打开 Nix-defined shell。如果使用的是 VSCode，在 Nix-defined shell 执行 `code .` 打开 VSCode 即可，VSCode 会继承 shell 中的环境。

## 1.2 通过 direnv

> 该方式适合用于远程服务器开发。

1. 配置 `direnv` + `nix-direnv`：

```bash
{
	programs.direnv = {
		enable = true;
		nix-direnv.enable = true;
	};
}
```

2. 在项目根目录创建 `.envrc`，在你的项目文件夹下（即 `flake.nix` 所在目录），运行：

```bash
echo "use flake" > .envrc
direnv allow
```

3. 安装 VS Code 插件

在远程 VS Code 的扩展商店（Extensions）里安装：

- [direnv (作者: Martin Kühl)](https://marketplace.visualstudio.com/items?itemName=mkhl.direnv)

效果：当你用 VS Code 打开这个文件夹时，底部的状态栏会显示 direnv 正在加载。加载完成后，VS Code 内部的终端、调试器和 LSP（如 clangd 或 pyright）都会自动拥有 nix develop 提供的工具链。
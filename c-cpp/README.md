# 1.补充

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

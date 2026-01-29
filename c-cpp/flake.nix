{
  description = "C++ Clang 开发环境";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # 如果是 ARM 架构则改为 aarch64-linux
      pkgs = import nixpkgs { inherit system; };
      # 创建一个基于 clang 的 shell
      chanllengedShell = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; };
    in
    {
      devShells.${system}.default = chanllengedShell {
        # 1. 编译和构建工具
        nativeBuildInputs = with pkgs; [
          cmake              # 构建工具
          ninja              # 更快的构建后端
          clang-tools        # 包含 clangd (LSP), clang-format, clang-tidy
          gdb                # gdb 调试器
          lldb_20            # lldb 调试器
        ];

        # 2. 运行时依赖库 (第三方库放这里)
        buildInputs = with pkgs; [
          # 示例：添加常用库
          llvmPackages.openmp
          eigen
          boost
          nlohmann_json
          fmt
        ];

        # 3. 环境变量设置
        CMAKE_EXPORT_COMPILE_COMMANDS=1;
        VERBOSE=1;  # 用 ninja 构建时输出详细信息

        # 4. 脚本
        shellHook = ''
          echo "C++ 开发环境已加载！"
          echo "编译器: $(clang --version | head -n 1)"
        '';
      };
    };
}

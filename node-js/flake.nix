{
  description = "Node.js 开发环境";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      # 建议使用此方式支持多架构 (x86_64-linux, aarch64-darwin 等)
      system = "x86_64-linux"; 
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        # 1. 开发工具 (编译时工具)
        nativeBuildInputs = with pkgs; [
          nodejs_20           # Node.js 运行时 (也可以选 nodejs_18, nodejs_22 等)
          yarn
          typescript-language-server # LSP 服务
          nodePackages.typescript    # tsc 编译器
          nodePackages.prettier      # 代码格式化
        ];

        # 2. 运行时依赖或系统库
        buildInputs = with pkgs; [
          # openssl
          # pkg-config
        ];

        # 环境变量设置
        shellHook = ''
          # 自动启用 corepack 以支持 pnpm/yarn
          # corepack enable --node-path ${pkgs.nodejs_20}/bin/node

          echo "Node.js 开发环境已加载！"
          echo "Node版本: $(node --version)"
          echo "NPM版本:  $(npm --version)"
          
          # 防止 node_modules 中的二进制文件找不到
          export PATH="$PWD/node_modules/.bin:$PATH"
        '';
      };
    };
}
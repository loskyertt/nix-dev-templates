{
  description = "Personal dev templates";

  outputs = _: {
    templates = {
      default = self.templates.c-cpp;   # 默认模板

      c-cpp = {
        path    = ./c-cpp;
        description = "C/C++ dev-shell with cmake, clangd, gdb";
      };

      node-js = {
        path    = ./node-js;
        description = "Node.js/typescript workspace";
      };
    };
  };
}

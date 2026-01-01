{
  description = "Personal dev templates";

  outputs = { self, ... }: {        # <-- 这里把 self 留下来
    templates = {
      c-cpp = {
        path        = ./c-cpp;
        description = "C/C++ dev-shell with cmake, clangd, gdb";
      };
      node-js = {
        path        = ./node-js;
        description = "Node.js/typescript workspace";
      };
    };
  };
}

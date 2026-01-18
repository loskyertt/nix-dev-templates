{
  description = "Personal dev templates";

  outputs = { self, ... }: {
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

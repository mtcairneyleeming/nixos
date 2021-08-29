final: prev:
with final.lib;
with {
  my-vscode-extensions =
    with final.vscode-extensions; [
      bbenoist.Nix
      ms-python.python
      ms-vscode-remote.remote-ssh
    ] ++
    final.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "nix-env-selector";
        publisher = "arrterian";
        version = "1.0.7";
        sha256 = "0mralimyzhyp4x9q98x3ck64ifbjqdp8cxcami7clvdvkmf8hxhf";
      }
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.1.16";
        sha256 = "04ky1mzyjjr1mrwv3sxz4mgjcq5ylh6n01lvhb19h3fmwafkdxbp";
      }
    ];
};
{
  vscode = pipe prev.vscode [
    (x: x.override {
      isInsiders = false;
    })
    (x: x.overrideAttrs (old: {
       
      # sudo-prompt has hardcoded binary paths on Linux and we patch them here
      # combining information from https://github.com/NixOS/nixpkgs/blob/fc553c0bc5411478e2448a707f74369ae9351e96/pkgs/tools/misc/etcher/default.nix#L49y
      # and https://github.com/NixOS/nixpkgs/issues/76526#issuecomment-569131432
      # and https://www.codepicky.com/hacking-electron-restyle-skype/
      postPatch = (old.postPatch or "") + ''
        # PATCHING RUN AS SUDO
        # --------------------
        # where to find the node.js librar .asar was described here https://github.com/NixOS/nixpkgs/issues/76526#issuecomment-569131432
        packed="resources/app/node_modules.asar"

        # we unpack directly into the same name without .asar ending,
        # which is adapted from hacking-skype-tutorial https://www.codepicky.com/hacking-electron-restyle-skype/
        unpacked="resources/app/node_modules"
        
        ${final.nodePackages.asar}/bin/asar extract "$packed" "$unpacked"

        # we change paths to pkexec and bash
        # as described here https://github.com/NixOS/nixpkgs/blob/fc553c0bc5411478e2448a707f74369ae9351e96/pkgs/tools/misc/etcher/default.nix#L49y
        sed -i "
          s|/usr/bin/pkexec|/run/wrappers/bin/pkexec|
          s|/bin/bash|${final.bash}/bin/bash|
        " "$unpacked/sudo-prompt/index.js"

        # delete original .asar file, as the new unpacked is now replacing it
        rm -rf "$packed"

        # PATCHING GLOBAL SEARCH
        # ----------------------
        chmod +x resources/app/node_modules/vscode-ripgrep/bin/rg
        '';
    }))
  ];
  vscode-with-extensions = pipe prev.vscode-with-extensions [
    (x: x.override {
      vscode = final.vscode;
      vscodeExtensions = my-vscode-extensions;
    })
  ];
}

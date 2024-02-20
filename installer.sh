#!/usr/bin/env sh
#
# NormalNvim installer.
# Supports: Arch, Ubuntu, MacOS, Termux, WSL


# Detect OS
IS_ARCH=$(if [ -f /etc/os-release ] && grep -q "NAME=\"Arch Linux\"" /etc/os-release; then echo "true"; else echo "false"; fi)
IS_UBUNTU=$(if [ -f /etc/os-release ] && grep -q "NAME=\"Ubuntu\"" /etc/os-release; then echo "true"; else echo "false"; fi)
IS_MACOS=$(if [ -d /Applications ] && [ -d /System ]; then echo "true"; else echo "false"; fi)
IS_TERMUX=$(if [ -x "$(command -v pkg)" ] && [ -d "$HOME/.termux" ]; then echo "true"; else echo "false"; fi)

# Currently unused
IS_WSL=$(if grep -q Microsoft /proc/version; then echo "true"; else echo "false"; fi)
IS_FEDORA=$(if [ -f /etc/fedora-release ]; then echo "true"; else echo "false"; fi)
IS_NIXOS=$(if [ -d /etc/nixos ] && [ -f /etc/os-release ] && grep -q "NAME=\"NixOS\"" /etc/os-release; then echo "true"; else echo "false"; fi)




## INSTALL NormalNvim
###############################################################################
echo
echo "Welcome to NormalNvim!"
echo "=================================================================="
echo "This installer will ask you for confirmation on every step before:"
echo "=================================================================="
echo "1) Clone NormalNvim on '~/.config/nvim'."
echo "2) (optional) We will ask you to fork NormalNvim on GitHub, and provide your GitHub username so we can change git remote origin to your fork."
echo "3) (optional) Install system dependencies, to unlock all features."
echo "=================================================================="
echo
echo
echo
echo
echo "Step 1: Cloning NormalNvim on ~/.config/nvim"
echo "------------------------------------------------------------------"
if [ -d ~/.config/nvim ]; then
  echo "ERROR: The directory ~/.config/nvim already exist."
  echo "       Please move it to a different location before installing."
  exit 1
fi
echo "INFO: Installing NormalNvim in '~/.config/nvim'"
git clone https://github.com/NormalNvim/NormalNvim.git ~/.config/nvim
cd ~/.config/nvim || echo 2>&1
echo "------------------------------------------------------------------"
echo "SUCCESS: NormalNvim installed correctly"
echo "------------------------------------------------------------------"
printf "PRESS ENTER TO CONTINUE"
read -r
echo
echo
echo
echo




## DETECT REMOTE ORIGIN
###############################################################################
echo "Step 2: Change git remote origin (optional)"
echo "------------------------------------------------------------------"
echo "* We recommend forking NormalNvim."
echo "* You can do it now."
echo "* We are gonna ask your GitHub username to set your"
echo "  git remote URL to git://github.com/<your_username>/NormalNvim.git"
echo ""
printf "Please, enter your GitHub username [leave blank to skip]: "
read -r github_username

# Check if the username is not empty
if [ -n "$github_username" ]; then
  # Change the remote URL
  git remote set-url origin "git://github.com/$github_username/NormalNvim.git"
  echo "------------------------------------------------------------------"
  echo "SUCCESS: GitHub username provided. You will get updates from:"
  echo "         git://github.com/$github_username/NormalNvim.git"
  echo "------------------------------------------------------------------"
else
  echo "------------------------------------------------------------------"
  echo "SKIPPED: No GitHub username provided. You will get updated from:"
  echo "         git://github.com/NormalNvim/NormalNvim.git"
  echo "------------------------------------------------------------------"
fi
echo
echo
echo
echo




## INSTALL DEPENDENCIES
###############################################################################
echo "Step 3: Install system dependencies (optional)"
echo "------------------------------------------------------------------"
printf "Do you want to install the dependencies? [Y/n]"
read -r answer
answer_lowercase=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
if [ -z "$answer_lowercase" ] || [ "$answer_lowercase" = "y" ] || [ "$answer_lowercase" = "yes" ]; then




  ## ARCH INSTALLER (dependencies)
  #############################################################################
  if [ "$IS_ARCH" = "true" ]; then
    echo "Arch Linux detected."

    # DETECT AUR CLIENT
    # -----------------
    if command -v paru > /dev/null 2>&1; then AUR_CMD="paru -S --needed";
    elif command -v yay > /dev/null 2>&1; then AUR_CMD="yay -S --needed"; fi

    # INSTALL DEPENDENCIES
    # --------------------
    if [ -n "$AUR_CMD" ]; then
      "$AUR_CMD" "python" "python-pynvim" "fd" "git-delta" "grcov" "rustup" "yarn" "python-pytest" "mingw-w64-gcc" "dotnet-runtime" "dotnet-sdk" "aspnet-runtime" "mono" "jdk-openjdk" "dart" "kotlin" "elixir" "npm" "nodejs" "typescript" "make" "go" "nasm" "r" "nuitka" "python" "ruby" "perl" "lua" "pyinstaller" "swift-bin" "doxygen"; yarn global add "jest" "jsdoc" "typedoc"; cargo install "cargo-nextest"; go install "golang.org/x/tools/cmd/godoc@latest"
    else
      echo "ERROR: You must have 'paru' or 'yay' installed so we can use the AUR."
    fi




  # UBUNTU INSTALLER (dependencies)
  #############################################################################
  elif [ "$IS_UBUNTU" = "true" ]; then
    echo "Ubuntu detected."
    sudo apt update; sudo apt install --install-if-missing "yarn" "ranger" "rust-fd-find" "python-pynvim" "python-pytest" "delta" "rust-grcov" "rustup" "mingw-w64" "dotnet8" "monodevelop" "java-common" "nasm" "r-base" "rustc" "golang" "python" "ruby" "perl" "lua5.3" "kotlin" "elixir" "make" "nodejs" "npm" "node-typescript" "nuitka"; yarn global add "jest" "jsdoc" "typedoc"; go install "golang.org/x/tools/cmd/godoc@latest"; sudo snap install --classic "flutter"




  # MACOS INSTALLER (dependencies)
  #############################################################################
  elif [ "$IS_MACOS" = "true" ]; then
    echo "MacOS detected."
    sudo brew install "fd" "git-delta" "rustup-init" "yarn" "mingw-w64" "dotnet" "mono" "openjdk" "dart-sdk" "kotlin" "elixir" "node" "typescript" "make" "rust" "go" "nasm" "r" "ruby" "perl" "lua" "swift" "pyinstaller" "doxygen"; sudo brew install --cask "dotnet-sdk" "flutter"; pip install "pynvim" "pytest" "Nuitka"; yarn add global "jest" "jsdoc" "typedoc"; cargo install "cargo-nextest" "grcov"; go install "golang.org/x/tools/cmd/godoc@latest"




  # TERMUX INSTALLER (dependencies)
  #############################################################################
  elif [ "$IS_TERMUX" = "true" ]; then
    echo "Termux detected."
    pkg install -y clang ranger binutils fd yarn rust swift && pip install pynvim pytest nuitka pyinstaller && yarn add global jest typedoc jdoc && pkg install -y dotnet-sdk mono openjdk-17 kotlin rust golang nasm python ruby perl lua53 dart nodejs elixir make doxygen && npm install -g typescript && go install golang.org/x/tools/cmd/godoc@latest && cargo install git-delta grcov




  # ERROR: OS NOT DETECTED
  #############################################################################
  else
    echo "ERROR: It seems your OS is not Arch Linux, Ubuntu, MacOS or Termux."
    echo "Your OS is not directly supported."
    echo "But you can still read the wiki and install the dependencies manually."
  fi




fi # End of install dependencies


# SUCCESS MESSAGE
###############################################################################
echo
echo
echo
echo
echo "NormalNvim has been correctly installed"
echo "========================================"
echo "The first time you open NormalNvim, it will install the next things concurrently:"
echo ""
echo "* PLUGINS:    → You can remove from your config the ones you don't want later."
echo "* MASON:      → Pre-configured LSP servers, linters, formatters and debuggers."
echo "* TREESITTER: → For improved syntax highlighting."
echo ""
echo "========================================"
echo "PRESS ENTER TO OPEN IT"
nvim -c ':NvimUpdatePlugins' -c ':MasonInstall lua-language-server prettierd eslint-lsp typescript-language-server css-lsp asm-lsp netcoredbg json-lsp codelldb firefox-debug-adapter chrome-debug-adapter rust-analyzer clangd omnisharp bash-language-server shellcheck jedi-language-server pylama flake8 autopep8 autoflake debugpy ruby-lsp taplo ktlint yaml-language-server neocmakelsp angular-language-server ansible-language-server dockerfile-language-server docker-compose-language-service helm-ls fsautocomplete fantomas perlnavigator kotlin-language-server svelte-language-server phpactor stylua csharpier bash-debug-adapter asmfmt java-test google-java-format dart-debug-adapter gopls golangci-lint gofumpt golangci-lint-langserver kotlin-debug-adapter rubocop beautysh gersemi cmakelint eslint_d markuplint php-cs-fixer phpstan delve matlab-language-server zls elixir-ls php-debug-adapter' -c ':TSInstall all' 2>&1

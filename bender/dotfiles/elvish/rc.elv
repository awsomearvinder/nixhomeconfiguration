fn ls {|@arg| exa -a $@arg }
fn lsl {|@arg| exa -al $@arg }
fn fucking {|@arg| sudo -E $@arg }
fn nixd {|@arg| nix develop --command elvish @arg }
fn nixb {|@arg| nix build $@arg }
fn nixr {|@arg| nix run $@arg }
fn gitl {|@arg| git log --graph --decorate $@arg }
fn gitll {|@arg| git log --graph --decorate --oneline $@arg }

var active_theme = "base16-gruvbox-dark-medium"
eval $active_theme'.sh'

eval (starship init elvish)

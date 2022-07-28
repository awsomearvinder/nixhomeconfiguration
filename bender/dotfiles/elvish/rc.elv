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

# Get enviornment variables from bash
# Pain.
use str
var bash_env_vars = [(
    bash -l -c "env -0" |
      from-terminated "\x00" |
      each { |item| put [(str:split &max=2 "=" $item)] }
)]
for item $bash_env_vars {
    if (and (not (has-env $item[0])) (not (str:contains '%' $item[0]))) {
        set-env $item[0] $item[1]
    }
}

eval (starship init elvish)

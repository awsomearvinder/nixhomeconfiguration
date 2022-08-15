fn ls {|@arg| exa -a $@arg }
fn lsl {|@arg| exa -al $@arg }
fn fucking {|@arg| sudo -E $@arg }
fn sodu {|@arg| sudo -E --preserve-env=PATH $@arg }
fn nixd {|@arg| nix develop --command elvish $@arg }
fn nixb {|@arg| nix build $@arg }
fn nixr {|@arg| nix run $@arg }
fn gitl {|@arg| git log --graph --decorate $@arg }
fn gitll {|@arg| git log --graph --decorate --oneline $@arg }

# utility combine map function
fn combine-arrays-dedup {|arr1 arr2|
    each {|item| put $item} $arr1
    each {|item| if (not (has-value $item $arr1)) { put $item }} $arr2
}
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
    # combine PATHs from bashrc. :)
    if (eq $item[0] "PATH") {
        var bash_path = [(str:split ':' $item[1])]
        var own_path = [(str:split ':' $E:PATH)]
        var combined_path = (str:join ':' [(combine-arrays-dedup $bash_path $own_path)])
        set-env "PATH" $combined_path
    } else {
        set-env $item[0] $item[1]
    }
}

set-env MOZ_ENABLE_WAYLAND 1
eval (starship init elvish)

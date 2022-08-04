fn ls {|@arg| exa -a $@arg }
fn lsl {|@arg| exa -al $@arg }
fn fucking {|@arg| sudo -E $@arg }
fn sodu {|@arg| sudo -E --preserve-env=PATH $@arg }
fn nixd {|@arg| nix develop --command elvish @arg }
fn nixb {|@arg| nix build $@arg }
fn nixr {|@arg| nix run $@arg }
fn gitl {|@arg| git log --graph --decorate $@arg }
fn gitll {|@arg| git log --graph --decorate --oneline $@arg }

# utility combine map function
fn combine-maps {|map1 map2|
    var map1_keys = [(keys $map1)]
    if (> (count $map1_keys) 0) {
      var map2_incremented = (assoc $map2 $map1_keys[0] $map1[$map1_keys[0]])
      var map1_decremented = (dissoc $map1 $map1_keys[0])
      put (combine-maps $map1_decremented $map2_incremented)
    } else {
      put $map2
    }
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
    if (and (not (has-env $item[0])) (not (str:contains '%' $item[0]))) {
        set-env $item[0] $item[1]
    }
    # combine PATHs from bashrc. :)
    if (eq $item[0] "PATH") {
        var bash_path = (str:split ':' $item[1] | each {|i| put [$i $true]} | make-map)
        var own_path = (str:split ':' $E:PATH | each {|i| put [$i $true]} | make-map)
        var combined_path = (keys (combine-maps $own_path $bash_path) | str:join ':')
        set-env "PATH" $combined_path
    }
}

eval (starship init elvish)

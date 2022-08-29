## hook for direnv
set @edit:before-readline = $@edit:before-readline {
    try {
        var m = [("/nix/store/3vql64vwk85jbqa14vw66nd2ngsqgv03-direnv-2.32.1/bin/direnv" export elvish | from-json)]
        if (> (count $m) 0) {
            set m = (all $m)
            keys $m | each { |k|
                if $m[$k] {
                    set-env $k $m[$k]
                } else {
                    unset-env $k
                }
            }
        }
    } catch e {
        echo $e
    }
}

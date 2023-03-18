{work_account, ...}: {
  dots = ./dotfiles;
  modifier =
    if !work_account
    then "Mod4"
    else "Mod1";
}

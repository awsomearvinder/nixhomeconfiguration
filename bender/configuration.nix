{work_account, ...}: {
  dots = ./dotfiles;
  scripts = ~/.config/scripts;
  modifier = if !work_account then "Mod4" else "Mod1";
}

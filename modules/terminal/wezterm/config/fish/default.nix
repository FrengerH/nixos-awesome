{
  enable = true;
  shellAliases = {
    l="ls -lvh";
    ll="ls -lvAh";
    cd="z";
    cdi="zi";
    ssh="TERM=xterm-256color /usr/bin/env ssh";
    cat="bat --theme CatppuccinMocha -p";
  };

  promptInit = ''
    any-nix-shell fish --info-right | source
  '';

  shellInit = ''
    starship init fish | source
    zoxide init fish | source
    
    set -gx XDG_CONFIG_HOME ~/.config/
    set -gx BAT_CONFIG_DIR /etc/bat/
    set -gx DOCKER_BUILDKIT 1

    set -g fish_term24bit 1

    # Theme colors
    set -l foreground cdd6f4  #cdd6f4
    set -l selection  45475a  #45475a
    set -l comment    89b4fa  #89b4fa
    set -l red        f38ba8  #f38ba8
    set -l orange     fab387  #fab387
    set -l yellow     f9e2af  #f9e2af
    set -l green      a6e3a1  #a6e3a1
    set -l purple     cba6f7  #cba6f7
    set -l cyan       74c7ec  #74e7ec
    set -l pink       f5c2e7  #f5c2e7

    # Syntax highlighting colors
    set -gx fish_color_normal         $foreground
    set -gx fish_color_command        $cyan
    set -gx fish_color_keyword        $pink
    set -gx fish_color_quote          $yellow
    set -gx fish_color_redirection    $foreground
    set -gx fish_color_end            $orange
    set -gx fish_color_error          $red
    set -gx fish_color_param          $purple
    set -gx fish_color_comment        $comment
    set -gx fish_color_selection      --background=$selection
    set -gx fish_color_search_match   --background=$selection
    set -gx fish_color_operator       $green
    set -gx fish_color_escape         $pink
    set -gx fish_color_autosuggestion $comment
    set -gx fish_color_cancel         $red --reverse
    set -gx fish_color_option         $orange

    # Default prompt colors
    set -gx fish_color_cwd            $green
    set -gx fish_color_host           $purple
    set -gx fish_color_host_remote    $purple
    set -gx fish_color_user           $cyan
    
    # Completion pager colors
    set -gx fish_pager_color_progress              $comment
    set -gx fish_pager_color_background
    set -gx fish_pager_color_prefix                $cyan
    set -gx fish_pager_color_completion            $foreground
    set -gx fish_pager_color_description           $comment
    set -gx fish_pager_color_selected_background   --background=$selection
    set -gx fish_pager_color_selected_prefix       $cyan
    set -gx fish_pager_color_selected_completion   $foreground
    set -gx fish_pager_color_selected_description  $comment
    set -gx fish_pager_color_secondary_background
    set -gx fish_pager_color_secondary_prefix      $cyan
    set -gx fish_pager_color_secondary_completion  $foreground
    set -gx fish_pager_color_secondary_description $comment

    set fish_vi_force_cursor 1
    set -U fish_cursor_default block
    set -U fish_cursor_insert line
    set -U fish_cursor_replace_one underscore
    set -U fish_cursor_visual block
    set -U fish_cursor_unknow line

    fish_vi_key_bindings
    function fish_user_key_bindings
      fish_vi_key_bindings --no-erase insert
      bind -M insert \cn accept-autosuggestion
      bind -M insert \cs 'zellij run -f -c -n projects -- ~/work/scripts/selector/result/bin/selector $XDG_CONFIG_HOME; commandline -f repaint-mode'
      bind -M default \cs 'zellij run -f -c -n projects -- ~/work/scripts/selector/result/bin/selector $XDG_CONFIG_HOME; commandline -f repaint-mode'
      bind -M insert \cw 'zellij run -f -c -n "ssh servers" -- ~/work/scripts/sshsel/result/bin/sshsel $HOME $XDG_CONFIG_HOME; commandline -f repaint-mode'
      bind -M default \cw 'zellij run -f -c -n "ssh servers" -- ~/work/scripts/sshsel/result/bin/sshsel $HOME $XDG_CONFIG_HOME; commandline -f repaint-mode'
    end

    function last_history_item; echo $history[1]; end
    abbr -a !! --position anywhere --function last_history_item

    function fish_greeting
    end

  '';
}

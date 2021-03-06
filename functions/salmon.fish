function salmon -d 'chips plugin.yaml generator; you probably don\'t want this'
  set -l chips_dist_dir $HOME/.config/chips/dist
  set -l chips_config_yaml $HOME/.config/chips/plugin.yaml

  # no args
  if not count $argv > /dev/null
    if not set -q SALMON_NO_OVERWRITE
      if set -q chips_github_repos[1]
        echo '# Auto-generated by salmon.fish' > $chips_config_yaml
        for line in $chips_github_repos
          if [ $line = '' ]
            echo 'github:' >> $chips_config_yaml
          else
            echo - $line >> $chips_config_yaml
          end
        end
      end
    end
    set -g chips_github_repos

    if set -q salmon_chips_sources[1]
      for l in $salmon_chips_sources
        source $l
      end
      return 1
    end
    set -g salmon_chips_sources
    return
  end

  if set -q chips_github_repos[1]
    set -l q (echo $argv[1] | perl -pe 's|/|\n|;s|/|\n|')
    if not set -q q[2]
      return
    end

    set -g chips_github_repos $chips_github_repos $q[1]/$q[2]

    set -l dir $chips_dist_dir/$q[2]

    if test -d $dir
      if set -q q[3]
        set -l path $dir/$q[3]
        if test -d $path
          set -l dir $path
        else if test -f $path
          set -l base_path (basename $path)
          # left prompt
          if [ $base_path = 'fish_prompt.fish' ]
            if not set -q salmon_fish_prompt_sourced
              set -g salmon_fish_prompt_sourced 'true'
              set -g salmon_chips_sources $salmon_chips_sources $path
            end
            return
          end

          # right prompt
          if [ $base_path = 'fish_right_prompt.fish' ]
            if not set -q salmon_fish_right_prompt_sourced
              set -g salmon_fish_right_prompt_sourced 'true'
              set -g salmon_chips_sources $salmon_chips_sources $path
            end
            return
          end

          set -g salmon_chips_sources $salmon_chips_sources $path
          return
        end
      end

      set -l plugin_is_sane ''

      if test -f $dir/init.fish
        set -g salmon_chips_sources $salmon_chips_sources $dir/init.fish
        set plugin_is_sane 'true'
      end

      if not set -q salmon_fish_prompt_sourced
          and test -f $dir/fish_prompt.fish
        set -g salmon_fish_prompt_sourced 'true'

        set -g salmon_chips_sources $salmon_chips_sources $dir/fish_prompt.fish
        set plugin_is_sane 'true'
      end

      if not set -q salmon_fish_right_prompt_sourced
          and test -f $dir/fish_right_prompt.fish
        set -g salmon_fish_right_prompt_sourced 'true'

        set -g salmon_chips_sources $salmon_chips_sources $dir/fish_right_prompt.fish
        set plugin_is_sane 'true'
      end

      if test -d $dir/functions
        for v in $dir/functions/*.fish
          if not [ (basename $v) = 'uninstall.fish' ]
            set -g salmon_chips_sources $salmon_chips_sources $v
          end
        end
        set plugin_is_sane 'true'
      end

      if test -d $dir/conf.d
        for v in $dir/conf.d/*.fish
          if not [ (basename $v) = 'uninstall.fish' ]
            set -g salmon_chips_sources $salmon_chips_sources $v
            set plugin_is_sane 'true'
          end
        end
      end

      if [ $plugin_is_sane = '' ]
        # it must be insane
        for v in $dir/*.fish
          if not [ (basename $v) = 'uninstall.fish' ]
            set -g salmon_chips_sources $salmon_chips_sources $v
          end
        end
        return
      else if test -f $dir/fishfile
        for v in (cat $dir/fishfile | grep -E '^[^/]+/[^/]+$')
          salmon $v
        end
      end
    else
      set -g chips_should_update true
    end
  end
end


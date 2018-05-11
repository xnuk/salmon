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
    set -l q (echo $argv[1] | sed 's|/|\n|;s|/|\n|')
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
          if echo $path | grep '/fish_prompt\.fish$' > /dev/null
            if not set -q salmon_fish_prompt_sourced
              set -g salmon_fish_prompt_sourced 'true'
              set -g salmon_chips_sources $salmon_chips_sources $path
            end
            return
          end

          set -g salmon_chips_sources $salmon_chips_sources $path
          return
        end
      end

      if test -f $dir/init.fish
        set -g salmon_chips_sources $salmon_chips_sources $dir/init.fish
      end

      if test -f $dir/fish_prompt.fish
        set -g salmon_fish_prompt_sourced 'true'
        set -g salmon_chips_sources $salmon_chips_sources $dir/fish_prompt.fish
      end

      if test -d $dir/functions
        for v in $dir/functions/*.fish
          set -g salmon_chips_sources $salmon_chips_sources $v
        end
      end
    else
      set -g chips_should_update true
    end
  end
end


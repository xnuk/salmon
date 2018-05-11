# 🍣
![works on my machine](https://cdn.rawgit.com/nikku/works-on-my-machine/v0.2.0/badge.svg)
> dunno why 🐟 and 🍟 become salmon but it generates [chips]' `plugin.yaml` from your `config.fish`

## Requirements
- [fish](https://github.com/fish-shell/fish-shell)
- [chips]

## Install
Copy the [`functions/salmon.fish`](./functions/salmon.fish)
to `~/.config/fish/functions/salmon.fish`:
```
cp functions/salmon.fish ~/.config/fish/functions/salmon.fish
```

Or download it:
```sh
curl --location --create-dirs --output ~/.config/fish/functions/salmon.fish \
  https://cdn.rawgit.com/xnuk/salmon/master/functions/salmon.fish
```

Or you can even download it by chips:
```yaml
# in ~/.config/chips/plugin.yaml:
github:
  - 'xnuk/salmon'
```

## How does it look like?
Before you configure, PLEASE backup your `~/.config/chips/plugin.yaml`,
or it'll overwrite it:
```sh
cp ~/.config/chips/plugin.yaml ~/.config/chips/plugin.yaml.backup
```

On your `~/.config/fish/config.fish`:
```fish
# This script overwrites ~/.config/chips/plugin.yaml
# If you don't want it, uncomment the following line:
# set -g SALMON_NO_OVERWRITE

if salmon
  # Collecting github repos
  set -g chips_github_repos ''

  # ------ Configuration START ------

  # Install plugin from repository
  salmon 'username/repo'

  # Or plugin in sub-directory
  salmon 'username/repo/shellscript'

  # Or single fish script in repository
  salmon 'username/repo/shellscript/activate.fish'

  # This is a shell script; you can play with logic!
  if [ $TERM = 'linux' ]
    salmon 'oh-my-fish/theme-nai'
  else
    salmon 'xtendo-org/tartar'
  end

  # ------ Configuration END ------

  # NOTE: This command will overwrite ~/.config/chips/plugin.yaml
  salmon
end

# Triggers if salmon finds not-installed-yet plugins.
if set -q chips_should_update
  chips
end
```

## [LICENSE](./LICENSE)
Distributed under the [Zlib License](https://opensource.org/licenses/Zlib).


[chips]: https://github.com/xtendo-org/chips

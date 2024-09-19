# nivel

Sixel graphics for nvim, WIP.
Right now just displays `test.png` when you hit `<leader>v`

## Requirements

This needs neovim and imagemagick.

## Usage

Include in your neovim `init.lua`:

```
require(plugin_name).setup({
        cell_pixel_width = 16,
        cell_pixel_height = 34,
})
```

To obtain the correct pixel width and height, you can run the `termsize` program
included in the `./bin` folder of this repo. It was compiled from `termsize.c`
and basically just reads TIOCGWINSZ for the terminal window size.

Unfortunately there is no way to automate this from within the plugin (please
tell me if there is another way).

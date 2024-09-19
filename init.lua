vim.api.nvim_command("set runtimepath+=.")
local plugin_name = 'nixel'

local function load()
        require(plugin_name).setup({
                cell_pixel_width = 16,
                cell_pixel_height = 34,
        })
end

-- Function to reload a plugin
local function reload_plugin()
        package.loaded[plugin_name] = nil -- Clear the module cache
        load()
        print(plugin_name .. " reloaded.")
end

load()
vim.keymap.set('n', '<leader>r', function() reload_plugin() end, { noremap = true, silent = true })

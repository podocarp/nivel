local M = {}

-- Define a default configuration
M.config = {
  cell_pixel_width = 8,
  cell_pixel_height = 16,
}

function M.setup(config)
  M.config = vim.tbl_extend('force', M.config, config or {})
  vim.keymap.set('n', '<leader>v', function() M.open_buffer_with_image("test.png") end, { noremap = true, silent = true })
end

---@param height number Number of rows
---@param width number Number of columns
---@param title string|nil Title of the float
local function open_window(height, width, title)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = buf })
  vim.api.nvim_set_option_value('modifiable', false, { buf = buf })

  -- set some options
  local opts = {
    title = title,
    style = "minimal",
    border = "single",
    relative = "cursor",
    width = width + 1,
    height = height + 1,
    focusable = false,
    row = 1,
    col = 1
  }

  local win = vim.api.nvim_open_win(buf, false, opts)

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    once = true,
    callback = function()
      vim.api.nvim_win_close(win, true)
    end,
  })

  return win
end

local function echoraw(str)
  vim.fn.chansend(vim.v.stderr, str)
end

---@param path string
---@param lnum number
---@param cnum number
local send_sequence = function(path, lnum, cnum)
  -- https://zenn.dev/vim_jp/articles/358848a5144b63#%E7%94%BB%E5%83%8F%E8%A1%A8%E7%A4%BA%E9%96%A2%E6%95%B0%E3%81%AE%E4%BE%8B
  -- save cursor pos
  echoraw("\x1b[s")
  -- move cursor pos
  echoraw(string.format("\x1b[%d;%dH", lnum, cnum))
  -- display sixels
  local res = vim.fn.system(string.format("magick %s sixel:-", path))
  -- local res = vim.fn.system(string.format("img2sixel %s", path))
  echoraw(res)
  -- restore cursor pos
  echoraw("\x1b[u")
end

---@param path string
--- Returns width, height of image
local function get_image_dimension(path)
  local result = vim.fn.system(string.format("identify -ping -format '%%[width] %%[height]' %s", path))
  local dimensions = {}
  for word in result:gmatch("%S+") do
    table.insert(dimensions, tonumber(word)) -- Convert strings to numbers if needed
  end

  return dimensions[1], dimensions[2]
end

---@param height number
---@param width number
--- Takes in width and height in pixels and returns number of rows and columns
function M.pixel_dims_to_cells(width, height)
  local rows = math.ceil(height / M.config.cell_pixel_height)
  local cols = math.ceil(width / M.config.cell_pixel_width)
  return rows, cols
end

---@param path string
function M.open_buffer_with_image(path)
  local width, height = get_image_dimension(path)
  local rows, cols = M.pixel_dims_to_cells(width, height)
  print(rows, cols)
  local win = open_window(rows, cols, path)

  vim.defer_fn(function()
    local win_position = vim.api.nvim_win_get_position(win)
    local y = win_position[1]
    local x = win_position[2]
    send_sequence("test.png", y + 2, x + 2)
  end, 1000)
end

return M

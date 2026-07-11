return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")
    notify.setup({
      stages = "fade_in_slide_out",
      timeout = 5000,
      background_colour = "#000000",
      max_width = function()
        return vim.o.columns
      end,
      wrap = false,
    })
    vim.notify = notify

    -- Weather notification for zip 74012
    vim.defer_fn(function()
      vim.fn.jobstart(
        { "curl", "-s", "--max-time", "5", "wttr.in/74012?format=%l:+%c+%t+%h+%w" },
        {
          stdout_buffered = true,
          on_stdout = function(_, data)
            local output = table.concat(data, "")
            if output and output ~= "" and not output:match("Unknown location") then
              -- Convert Celsius to Fahrenheit
              local result = output:gsub("([+-]?%d+)°C", function(c)
                local f = math.floor(tonumber(c) * 9 / 5 + 32 + 0.5)
                return f .. "°F"
              end)
              -- Convert km/h to mph
              result = result:gsub("(%d+)km/h", function(kmh)
                local mph = math.floor(tonumber(kmh) * 0.621371 + 0.5)
                return mph .. "mph"
              end)
              vim.notify(result:gsub("^%s*(.-)%s*$", "%1"), vim.log.levels.INFO, { title = "Weather" })
            else
              vim.notify("Could not load weather", vim.log.levels.WARN, { title = "Weather" })
            end
          end,
          on_stderr = function() end,
          on_exit = function(_, code)
            if code ~= 0 then
              vim.notify("Could not load weather", vim.log.levels.WARN, { title = "Weather" })
            end
          end,
        }
      )
    end, 1000)
  end,
}

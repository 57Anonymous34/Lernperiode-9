local love = require "love"

function Button(text, func, func_param, width, height)
    return {
        width = width or 100,
        height = height or 50,
        func = func or function() print("This button has no function attached") end,

        func_param = func_param,
        text = text or "No Text",
        button_x = 0,
        button_y = 0,

        checkPressed = function(self, mouse_x, mouse_y, cursor_radius)
            if (mouse_x + cursor_radius >= self.button_x) and (mouse_x - cursor_radius <= self.button_x + self.width) then
                if (mouse_y + cursor_radius >= self.button_y) and (mouse_y - cursor_radius <= self.button_y + self.height) then
                    if self.func_param ~= nil then
                        self.func(self.func_param)
                    else
                        self.func()
                    end
                end
            end
        end,

        draw = function(self, button_x, button_y)
            self.button_x = button_x or self.button_x
            self.button_y = button_y or self.button_y

            love.graphics.setColor(0.6, 0.6, 0.6)
            love.graphics.rectangle("fill", self.button_x, self.button_y, self.width, self.height)

            love.graphics.setColor(0, 0, 0)

            local buttonFont = love.graphics.newFont(20)
            love.graphics.setFont(buttonFont)

            local text_y = self.button_y + (self.height - buttonFont:getHeight()) / 2

            love.graphics.printf(
                self.text,
                self.button_x,
                text_y,
                self.width,
                "center"
            )

            love.graphics.setColor(1, 1, 1)
        end,
    }
end

return Button
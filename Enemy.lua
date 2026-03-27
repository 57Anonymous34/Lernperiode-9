local love = require "love"

function Enemy(level)
    local dice = math.random(1, 4)
    local _x, _y
    local _radius = 20

    if dice == 1 then
        _x = math.random(_radius, love.graphics.getWidth())
        _y = -_radius * 4
    elseif dice == 2 then
        _x = -_radius * 4
        _y = math.random(_radius, love.graphics.getHeight())
    elseif dice == 3 then
        _x = math.random(_radius, love.graphics.getWidth())
        _y = love.graphics.getHeight() + (_radius * 4)
    else
        _x = love.graphics.getWidth() + (_radius * 4)
        _y = math.random(_radius, love.graphics.getHeight())
    end

    return {
        level = level or 2,
        radius = _radius,
        x = _x,
        y = _y,

        checkTouched = function(self, player_x, player_y, cursor_radius)
            return math.sqrt((self.x - player_x)^2 + (self.y - player_y)^2) <= cursor_radius + self.radius
        end,

        move = function(self, player_x, player_y)
            local dx = player_x - self.x
            local dy = player_y - self.y
            local distance = math.sqrt(dx * dx + dy * dy)

            if distance > 0 then
                self.x = self.x + (dx / distance) * self.level
                self.y = self.y + (dy / distance) * self.level
            end
        end,

        draw = function(self)
            love.graphics.setColor(1, 0.5, 0.7)
            love.graphics.circle("fill", self.x, self.y, self.radius)
            love.graphics.setColor(1, 1, 1)
        end,
    }
end

return Enemy
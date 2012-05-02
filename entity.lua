require 'math'

Entity = Object:extend()

function Entity:init(prop)
    self.prop = under.extend({
        x = 0,
        y = 0,
        w = 0,
        h = 0,
        z = 0,
    }, prop or {})

    under.extend(self, pick(self.prop, {'x', 'y', 'z', 'w', 'h'}))
end


function Entity:update(dt)
end

function Entity:draw()
end

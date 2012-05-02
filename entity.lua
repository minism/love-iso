require 'math'

Entity = Object:extend()

function Entity:init(prop)
    self.prop = under.extend({
        x = 0,
        y = 0,
    }, prop or {})
end


function Entity:update(dt)
end

function Entity:draw()
end

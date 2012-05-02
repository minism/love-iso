require 'math'
require 'iso'

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

-- Return x, y, rot, sx, sy for this entity to be transformed before corrected by iso
-- This is the inverse transformation of iso.applyMatrix()
-- This must be done so that we can use hardware matrices for positioning everything instead 
-- of positioning entities by hand
-- This function will likely get consumed by love.graphics transforms or spritebatch:addq
function Entity:getPreTransform()
    local x = self.x - self.w / 2 - self.z
    local y = self.y + self.h / 2 - self.z
    local rot = -iso.angle
    local sx = 1 / iso.scale.x
    local sy = 1 / iso.scale.y
    return x, y, rot, sx, sy
end

function Entity:getRect()
    return self.x - self.z, self.y - self.z, self.w, self.h
end

function Entity:update(dt)
end

function Entity:draw()
    love.graphics.push()
        local x, y, rot, sx, sy = self:getPreTransform()
        -- Position bottom of entity in center
        love.graphics.translate(x - self.w / 2, y - self.h / 2)
        love.graphics.rotate(rot)
        love.graphics.scale(sx, sy)
        self:drawLocal()
    love.graphics.pop()
end

function Entity:drawLocal()
    -- NOP
end


SpriteEntity = Entity:extend()

function SpriteEntity:init(prop)
    Entity.init(self, under.extend({
        
    }, prop or {}))

    self.sprite = prop.sprite
end

function SpriteEntity:drawLocal()
    love.graphics.draw(self.sprite)
end

Villiager = SpriteEntity:extend()

function Villiager:init(prop)
    SpriteEntity.init(self, under.extend({
        w = 16,
        h = 16,
        sprite = assets.gfx.v,
    }, prop or {}))
end


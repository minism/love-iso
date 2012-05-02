require 'geo'

Tile = Object:extend()

function Tile:init(prop)
    self.prop = under.extend({
        x = 0,
        y = 0,
        w = 0,
        h = 0,
    }, prop or {})
    self.x, self.y = self.prop.x, self.prop.y
    self.w, self.h = self.prop.w, self.prop.h
    self.hover = false
end

function Tile:draw()
    love.graphics.push()
        love.graphics.setColor(255, 255, 255)
        if self.hover then
            love.graphics.setPixelEffect(assets.shaders.brighten)
        end
        love.graphics.translate(self.x, self.y)
        geo.undoIsoMatrix()
        love.graphics.translate(-self.w * 2 / 3 - 1, 0)
        love.graphics.draw(assets.gfx.tile)
        if self.hover then
            love.graphics.setPixelEffect()
        end
    love.graphics.pop()
end

function Tile:update(dt)
    self.hover = false
end


Area = Object:extend()

function Area:init(prop)
    self.prop = under.extend({
        tilesize = 24,
        areasize = 50,
    }, prop or {})

    -- Setup tiles
    self.tiles = {}
    for i=1, self.prop.areasize do
        self.tiles[i] = {}
        for j=1, self.prop.areasize do
            -- Create tile in world space
            self.tiles[i][j] = Tile {
                x = (i - 1) * self.prop.tilesize,
                y = (j - 1) * self.prop.tilesize,
                w = self.prop.tilesize,
                h = self.prop.tilesize,
            }
        end
    end

    -- Setup spritebatch
    self.spritebatch = love.graphics.newSpriteBatch(assets.gfx.tileset, self.prop.areasize * self.prop.areasize)
    self.texquads = {
        love.graphics.newQuad(0, 0, 32, 16, 128, 16),
        love.graphics.newQuad(32, 0, 32, 16, 128, 16),
        love.graphics.newQuad(64, 0, 32, 16, 128, 16),
        love.graphics.newQuad(96, 0, 32, 16, 128, 16),
    }

end

function Area:update(dt)
    map2d(self.tiles, function(tile) tile:update(dt) end)
end


function Area:draw()
    love.graphics.push()
        self.spritebatch:clear()
        -- Draw transformed quads for each tile so iso transformation is correct
        map2d(self.tiles, function(tile)
            self.spritebatch:addq(self.texquads[1], tile.x, tile.y, 
                                  config.isoAngle, 1/config.isoScale[1], 1/config.isoScale[2])
        end)
        geo.applyIsoMatrix()
        love.graphics.draw(self.spritebatch)
    love.graphics.pop()
end

-- Get a tile from ortho world coords
function Area:tileAt(wx, wy)
    for i=1, #self.tiles do
        for j=1, #self.tiles[i] do
            local tile = self.tiles[i][j]
            if geo.contains(tile.x, tile.y, tile.x+tile.w, tile.y+tile.h, wx, wy) then
                return tile
            end
        end
    end
    return nil
end

-- Hover over iso world position
function Area:hover(iso_x, iso_y)
    local tile = self:tileAt(geo.toOrtho(iso_x, iso_y))
    if tile then
        tile.hover = true
    end
end

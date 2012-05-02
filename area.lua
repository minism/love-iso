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
    if self.hover then
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    end
    love.graphics.setColor(0, 50, 200, 200)
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
end

function Tile:update(dt)
    self.hover = false
end


Area = Object:extend()

function Area:init(prop)
    self.prop = under.extend({
        tilesize = 16,
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
end

function Area:update(dt)
    map2d(self.tiles, function(tile) tile:update(dt) end)
end


function Area:draw()
    love.graphics.push()
        love.graphics.scale(unpack(config.isoScale))
        love.graphics.rotate(config.isoAngle)
        map2d(self.tiles, function(tile) tile:draw() end)
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

require 'geo'
require 'iso'
require 'math'
require 'color'

Tile = Object:extend()

function Tile:init(prop)
    self.prop = under.extend({
        x = 0,
        y = 0,
        w = 0,
        h = 0,
        z = 0,
    }, prop or {})
    self.x, self.y = self.prop.x, self.prop.y
    self.w, self.h = self.prop.w, self.prop.h
    self.z = self.prop.z
end

Area = Object:extend()

function Area:init(prop)
    self.prop = under.extend({
        tilesize = 32 / math.sqrt(2),
        areasize = 32,
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
    self.texquads = build_quads(assets.gfx.tileset, 32, 32)

    -- Other entities
    self.cursor = {
        x = 0,
        y = 0,
        z = 0,
    }
end

function Area:update(dt)
    --
end


function Area:draw()
    love.graphics.push()
        -- Clear last frame
        self.spritebatch:clear()

        -- Prepraed transformed quads for each tile so iso transformation is correct
        map2d(self.tiles, function(tile)
            self.spritebatch:addq(self.texquads[1], tile.x - tile.w / 2 - tile.z, tile.y + tile.h / 2 - tile.z, 
                                  -iso.angle, 1/iso.scale.x, 1/iso.scale.y)
        end)
        color.white()
        love.graphics.draw(self.spritebatch)

        -- Draw cursor
        color.white(80)
        love.graphics.rectangle('fill', self.cursor.x - self.cursor.z, self.cursor.y - self.cursor.z, self.prop.tilesize, self.prop.tilesize)
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
    local wx, wy = iso.toOrtho(iso_x, iso_y)
    map2d(self.tiles, function(tile)
        if geo.contains(tile.x, tile.y, tile.x+tile.w, tile.y+tile.h, wx, wy) then
            self.cursor.x, self.cursor.y, self.cursor.z = tile.x, tile.y, tile.z
        end
    end)
end

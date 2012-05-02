require 'geo'
require 'iso'
require 'math'
require 'color'

Tile = Entity:extend()

function Tile:init(prop)
    Entity.init(self, under.extend({
        id = 1,
    }, prop or {}))
    self.id = self.prop.id
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
    console:write(#self.texquads)
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
            self.spritebatch:addq(self.texquads[tile.id], tile:getPreTransform())
        end)
        color.white()
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


-- TEST method
function Area:createWater(tile)
    for i=1, #self.tiles do
        for j=1, #self.tiles[i] do
            if self.tiles[i][j] == tile then
                for k=-1, 1 do
                    for l=-1, 1 do
                        if k == 0 and l == 0 then
                            self.tiles[i][j].id = 2
                        else
                            local k, l = i + k, j + l
                            if self.tiles[k] and self.tiles[k][l] 
                                and self.tiles[k][l].id ~= 2 then self.tiles[k][l].id = 3 end
                        end
                    end
                end
            end
        end
    end
end

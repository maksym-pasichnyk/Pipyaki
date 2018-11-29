-- SpriteRenderer = class()

-- function SpriteRenderer:new()
--     self.threshold = 4
--     self.pending = { image = nil, draws = 0 }
--     self.image = nil
--     self.stack = {}
--     self.color = { 255, 255, 255, 255 }
--     self.batches = {}
-- end

-- local function switchActiveImage(self, image)
--     if self.image then
--         local batch = self.batches[self.image]
--         love.graphics.draw(batch.sb)
--         batch.sb:clear()
--         batch.count = 0
--     end
    
--     if image then
--         local batch = self.batches[image]
--         if not batch then
--             batch = {}
--             batch.count = 0
--             batch.capacity = 1024
--             batch.sb = love.graphics.newSpriteBatch(image, batch.capacity, "stream")
--             self.batches[image] = batch
--         end
--     end

--     self.image = image
-- end

-- local function flushAndDraw(self, ...)
--     self:flush()
--     return love.graphics.draw(...)
-- end

-- function SpriteRenderer:flush()
--     switchActiveImage(self, nil)
-- end

-- function SpriteRenderer:draw(image, ...)
--     if image ~= self.image then
--         if not self.batches[image] then
--             if not image:typeOf("Texture") then
--                 return flushAndDraw(self, image, ...)
--             end

--             if image ~= self.pending.image then
--                 self.pending.image = image
--                 self.pending.draws = 0
--             end
--             self.pending.draws = self.pending.draws + 1
--             if self.pending.draws < self.threshold then
--                 return flushAndDraw(self, image, ...)
--             end
--         end

--         self.pending.image = nil
--         switchActiveImage(self, image)
--     end

--     local batch = self.batches[self.image]
--     if batch.count == batch.capacity then
--         return flushAndDraw(self, image, ...)
--     end
--     batch.sb:add(...)
--     batch.count = batch.count + 1
-- end
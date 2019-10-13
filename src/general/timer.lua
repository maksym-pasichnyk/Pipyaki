local function _nothing_() end

local interpolation = {
	linear = function(s) return s end
}

local function tween_collect_payload(subject, target)
	local out = {}

	for k, v in pairs(target) do
		table.insert(out, { k, v - subject[k] })
	end

	return out
end

Timer = class()
function Timer:new()
	self.functions = {}
end

function Timer:update(dt)
	local to_update = {}
	for handle in pairs(self.functions) do
		to_update[handle] = handle
	end

	for handle in pairs(to_update) do
		if self.functions[handle] then
			handle.time = handle.time + dt

			handle.step(dt)
			handle.during(dt, math.max(handle.limit - handle.time, 0))

			while handle.time >= handle.limit and handle.count > 0 do
				if handle.after(handle.after) == false then
					handle.count = 0
					break
				end
				
				handle.time = handle.time - handle.limit
				handle.count = handle.count - 1
			end

			if handle.count == 0 then
				self.functions[handle] = nil
			end
		end
	end
end

function Timer:during(delay, during, after)
	local handle = { time = 0, during = during, step = _nothing_, after = after or _nothing_, limit = delay, count = 1 }
	self.functions[handle] = true
	return handle
end

function Timer:after(delay, func)
	return self:during(delay, _nothing_, func)
end

function Timer:every(delay, after, count)
	local count = count or math.huge
	local handle = { time = 0, during = _nothing_, step = _nothing_, after = after, limit = delay, count = count }
	self.functions[handle] = true
	return handle
end

function Timer:tween(len, subject, target, method)
	local method = interpolation[method] or interpolation.linear

	local payload = tween_collect_payload(subject, target)

	local t = 0
	local last_s = 0

	local function update(dt)
		t = t + dt
		
		local s = method(math.min(1, t/len))
		local ds = s - last_s

		for i, info in ipairs(payload) do
			local key, delta = unpack(info)

			subject[key] = subject[key] + delta * ds
		end

		last_s = s
	end

	return self:during(len, update, _nothing_)
end

function Timer:cancel(handle)
	self.functions[handle] = nil
end

function Timer:script(f)
	local co = coroutine.wrap(f)
	co(function(t)
		self:after(t, co)
		coroutine.yield()
	end)
end

function Timer:clear()
	for k, v in pairs(self.functions) do
		self.functions[k] = nil
	end
	self.functions = {}
end
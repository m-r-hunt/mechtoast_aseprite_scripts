app.transaction(function()

local spr = app.activeSprite
if not spr then
	app.alert("There is no sprite to export")
	return
end

loop_layers = {}
for i,layer in ipairs(spr.layers) do
	if layer.name:find("Loop") then
		table.insert(loop_layers, {layer = layer})
	end
end

for i, layer in ipairs(loop_layers)do
	local loop_count = 0
	layer.cels = {}
	for j, cel in ipairs(spr.cels) do
		if cel.layer == layer.layer then
			loop_count = loop_count + 1
			layer.cels[cel.frameNumber] = cel
		end
	end
	layer.loop_length = loop_count
end

function gcd(a, b)
	while b ~= 0 do
		t = b
		b = a % b
		a = t
	end
	return a
end

function lcm(a, b)
	return a * b / gcd(a, b)
end

local combined_loop_length = loop_layers[1].loop_length
for i = 2,#loop_layers do
	combined_loop_length = lcm(combined_loop_length, loop_layers[i].loop_length)
end

while #spr.frames < combined_loop_length do
	spr:newEmptyFrame()
end

for i, layer in ipairs(loop_layers) do
	for j = layer.loop_length+1, #spr.frames do
		local celn = j % layer.loop_length
		if celn == 0 then
			celn = layer.loop_length
		end
		spr:newCel(layer.layer, j, layer.cels[celn].image, layer.cels[celn].position)
	end
end

end)

local LovePrint = {}

function LovePrint.add(data)
	if type(data) == "table" then
		for key, value in pairs(data) do
			print(key .. ": ", value)
		end
	end
end

return LovePrint

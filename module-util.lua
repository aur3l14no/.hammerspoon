function myprint(x)
    hs.console.printStyledtext(x)
end

function myAlert(msg)
    alert = hs.notify.new({title="Hammerspoon", informativeText=msg})
    alert:withdrawAfter(3):send()
end

function randomlyDisturb(base)
    local coef = 0.01
    base.w = base.w + (math.random() * 2 - 1) * coef
    base.h = base.h + (math.random() * 2 - 1) * coef
    base.x = base.x + (math.random() * 2 - 1) * coef
    base.y = base.y + (math.random() * 2 - 1) * coef
    if base.x < 0 then base.x = 0 end
    if base.x + base.w > 1 then base.x = 1 - base.w end
    if base.y < 0 then base.y = 0 end
    if base.y + base.h > 1 then base.y = 1 - base.h end
    return base
end

function map(f, t)
    local o = {}
    for i = 1, #t do
        o[#o + 1] = f(t[i])
    end
    return o
end

function sleep(n)
    local t = os.clock()
    while os.clock() - t <= n do
        -- nothing
    end
end

-- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console/42062321#42062321
function printTable(node)
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. string.rep('\t',depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. string.rep('\t',depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end

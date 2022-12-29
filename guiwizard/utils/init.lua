function table.table_copy(t)
    local t2 = {}
    for k,v in pairs(t) do
       t2[k] = v
    end
    return t2
end

function math.round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function ResizeImage(srcsize, targetsize)
    -- handy algorithm for dynamic resizing from
    -- https://stackoverflow.com/a/5710801

    local target_ratio = targetsize[1] / targetsize[2]
    local orig_ratio = srcsize[1] / srcsize[2]

    local finalsize = {targetsize[1],targetsize[2]}
    if orig_ratio < target_ratio then
        -- Limited by height
        finalsize[1] = math.round(targetsize[1] * orig_ratio)
    else
        -- Limited by width
        finalsize[2] = math.round(targetsize[2] / orig_ratio)
    end
    return finalsize
end
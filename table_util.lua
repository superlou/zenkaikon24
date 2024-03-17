-- From https://stackoverflow.com/questions/49709998/how-to-filter-a-lua-array-inplace
function filter_inplace(arr, func)
    local new_index = 1
    local size_orig = #arr
    for old_index, v in ipairs(arr) do
        if func(v, old_index) then
            arr[new_index] = v
            new_index = new_index + 1
        end
    end
    for i = new_index, size_orig do arr[i] = nil end
end

function split_every_n(array, n)
    local result = {}

    local current_page_index = 1
    local current_page = {}

    for i = 1, #array do
        if #current_page == n then
            table.insert(result, current_page)
            current_page = {}
        end

        table.insert(current_page, array[i])
    end

    if #current_page > 0 then
        table.insert(result, current_page)
    end

    return result
end

function array_contains(array, value)
    for _, item_value in ipairs(array) do
        if item_value == value then return true end
    end
    return false
end
local function split_every_n(array, n)
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

return {
    split_every_n = split_every_n
}
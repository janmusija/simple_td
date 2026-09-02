-- array.lua
local array = {}
-- quick implementation of 1-indexed arrays

array.reset = function(ARR) -- clear array. due to Limitations does not work to create a fresh array from scratch.
    ARR.__size = 0
    ARR.__array = {}
end

array.new = function() -- create a fresh array and return it
    local ARR = {}
    array.reset(ARR)
    return ARR
end

array.append =function(ARR,app) -- append something to the array
    ARR.__size = ARR.__size + 1
    ARR.__array[ARR.__size] = app
end

array.delete = function(ARR,i) -- delete and move last element to this position if element deleted was not last. So deleting the 2nd position from {0,1,2,3,4,5} yields {0,5,2,3,4}.
    assert(ARR.__size >= i, "index " .. i .. " too large!!")
    assert(i > 0, "index " .. i .. " too small!!")
    assert(ARR.__array[i], "index " .. i .. "does not exist!!")
    ARR.__array[i] = ARR.__array[ARR.__size]
    ARR.__array[ARR.__size] = nil
    ARR.__size = ARR.__size - 1
end

array.delete_shift = function(ARR,i) -- delete and move elements over. slower but more intuitive.
    assert(ARR.__size >= i, "index " .. i .. " too large!!")
    assert(i > 0, "index " .. i .. " too small!!")
    assert(ARR.__array[i], "index " .. i .. "does not exist!!")
    for j = i, ARR.__size-1 do
    ARR.__array[j] = ARR.__array[j+1]
    end
    ARR.__array[ARR.__size] = nil
    ARR.__size = ARR.__size - 1
end

array.insert = function(ARR,i,app) -- insert an element at position i
    assert(ARR.__size >= i+1, "index " .. i .. " too large!!")
    assert(i > 0, "index " .. i .. " too small!!")
    ARR.__size = ARR.__size + 1
    for j = ARR.__size, i,-1 do
        ARR.__array[j] = ARR.__array[j-1]
    end
    ARR.__array[i] = app 
end

array.get = function(ARR, i)
    assert(ARR.__size >= i, "index " .. i .. " too large!!")
    assert(i > 0, "index " .. i .. " too small!!")
    assert(ARR.__array[i], "index " .. i .. "does not exist!!")
    return ARR.__array[i]
end

array.size = function(ARR)
    return ARR.__size
end

return array
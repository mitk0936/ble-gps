local tmr_helper = require('lib/tmr');

local function split_by_chunk (text, chunk_size)
    local s = {};

    for i=1, #text, chunk_size do
        s[#s+1] = text:sub(i, i + chunk_size - 1)
    end

    return s
end

local read = function (softuart_instance, write_ble)
  softuart_instance:on('data', 128, function(line)
    local st = split_by_chunk(line, 16);

    for i,v in ipairs(st) do
       write_ble(v);
    end
  end);
end

tmr_helper.set_timeout(4000, function ()
  local softuart_instance = softuart.setup(9600, 1, 2);

  read(softuart_instance, function (message)
    softuart_instance:write(message);
  end);
end);

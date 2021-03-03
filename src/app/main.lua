local tmr_helper = require('lib/tmr');
local lua_nmea = require('lib/nmea');

local GGA_regex = 'GGA,%d+.%d+,.+,%*%d+';

local read
local parser = function (line, on_decode)
  local parsed = nil;
  local lines = {};
  local parsed = nil;

  print('<<<', line, '\n');

  for capture in string.gmatch(line, GGA_regex) do
    parsed = true;
    
    table.insert(lines, '$GP'..capture);

    local decoded = lua_nmea.decode('$GP'..capture);

    print('\n\n');
    print(decoded.latitude, decoded.longitude, decoded.map, decoded.satelite);
    print('\n\n');

    if (decoded.latitude and decoded.longitude) then
      on_decode('LA'..decoded.latitude);
      on_decode('LO'..decoded.longitude..'|');
    end

  end

  return parsed, lines;
end

read = function (softuart_instance, write_ble)
  softuart_instance:on('data', 128, function(line)

    parser(line, function (line)
      write_ble(line);
    end);

    read(softuart_instance, write_ble);
  end);
end

tmr_helper.set_timeout(4000, function ()
  local softuart_instance = softuart.setup(9600, 1, 2);

  read(softuart_instance, function (message)
    softuart_instance:write(message);
  end);
end);
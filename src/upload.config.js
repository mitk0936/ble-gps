module.exports = {
  connectionDelay: 200,
  baud: 115200,
  source: {
    libs: [
      '../lib/nodemcu-esp8266-helpers/tmr.lua',
      '../lib/lua-nmea/src/nmea.lua'
    ],
    scripts: './app/*.lua'
  }
};

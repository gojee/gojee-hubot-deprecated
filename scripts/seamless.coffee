# Description:
#   Gojee Seamless
#
# Dependencies:
#   http
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Author:
#   rickyc

module.exports = (robot) ->

  robot.respond /seamless/gi, (msg) ->
    options =
      host: 'gojee-seamless.herokuapp.com',
      port: 80,
      path: '/'

    require('http').get options, (response) ->
      response.on 'data', (chunk) ->
        item = JSON.parse(chunk)['item']
        msg.send item[0]['text']
        msg.send item[1]['text']

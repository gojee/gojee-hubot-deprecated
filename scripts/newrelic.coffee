module.exports = (robot) ->
  robot.respond /newrelic me/i, (msg) ->
    accountId = process.env.HUBOT_NEWRELIC_ACCOUNT_ID
    appId     = process.env.HUBOT_NEWRELIC_APP_ID
    apiKey    = process.env.HUBOT_NEWRELIC_API_KEY
    Parser = require("xml2js").Parser
    
    msg.http("https://rpm.newrelic.com/accounts/#{accountId}/applications/#{appId}/threshold_values.xml?api_key=#{apiKey}")
      .get() (err, res, body) ->
        if err
          msg.send "New Relic says: #{err}"
          return

        (new Parser).parseString body, (err, json)->
          threshold_values = json['threshold_value'] || []
          lines = threshold_values.map (threshold_value) ->
            "#{threshold_value['@']['name']}: #{threshold_value['@']['formatted_metric_value']}"
             
          msg.send lines.join("\n"), "https://rpm.newrelic.com/accounts/#{accountId}/applications/#{appId}"

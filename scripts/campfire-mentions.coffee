# Description:
#   [Campfire] An email is sent to the user when they get mentioned!
#
# Dependencies:
#   sendgrid
#
# Configuration:
#   HUBOT_SENDGRID_USER
#   HUBOT_SENDGRID_KEY
#
# Commands:
#   hubot mentions assign email foo@bar.com to baz
#   hubot mentions remove user baz
#   hubot mentions list users
#   hubot mentions help
#
# Author:
#   rickyc


module.exports = (robot) ->
  util = require 'util'
  robot.brain.data.mentions_nicknames ?= {}

  send_email = (mail_options) ->
    SendGrid = require('sendgrid').SendGrid
    sendgrid = new SendGrid(process.env.HUBOT_SENDGRID_USER, process.env.HUBOT_SENDGRID_KEY)
    sendgrid.send mail_options, (success, message) ->
        robot.logger.error message unless success

  robot.hear /@(\w+)/gi, (msg) ->
    @current_user = msg.message.user.name
    @room_id = msg.message.user.room
    message = msg.message.text

    for user in msg.match
      mentioned_user = user.slice(1)
      continue unless robot.brain.data.mentions_nicknames[mentioned_user]?

      mail_options =
        to: robot.brain.data.mentions_nicknames[mentioned_user]
        from: 'no-reply'
        subject: "#{@current_user} mentioned you in Campfire [#{process.env.HUBOT_CAMPFIRE_ACCOUNT}]"
        html: "Hi #{mentioned_user.charAt(0).toUpperCase()}#{mentioned_user.slice(1)},
          <p>#{@current_user} just mentioned you in the room [#{@room_id}].</p>
          <b>#{@current_user}:</b> #{message}"

    send_email mail_options


  # add email to nickname
  robot.respond /mentions assign email (.+)? to ([^\s]+)/i, (msg) ->
    [email, nickname] = [ msg.match[1], msg.match[2]]
    robot.brain.data.mentions_nicknames[nickname] = email


  # delete nickname
  robot.respond /mentions remove user ([^\s]+)/i, (msg) ->
    delete robot.brain.data.mentions_nicknames[msg.match[1]]


  # list users
  robot.respond /mentions list users/i, (msg) ->
    msg.send util.inspect robot.brain.data.mentions_nicknames


  # help
  robot.respond /mentions help/i, (msg) ->
    msg.send """
     hubot mentions assign email contact@example.com to example
     hubot mentions remove user example
     hubot mentions list users
   """

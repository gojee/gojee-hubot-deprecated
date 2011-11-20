Robot    = require('hubot').robot()
Adapter  = require('hubot').adapter()

flowdock = require 'flowdock'

class Flowdock extends Adapter
  send: (user, strings...) ->
    for str in strings
      @bot.chatMessage(user.flow.subdomain, user.flow.name, str)

  reply: (user, strings...) ->
    for str in strings
      @send user, "#{user.name}: #{str}"

  run: ->
    options =
      login_email:    process.env.HUBOT_FLOWDOCK_LOGIN_EMAIL
      login_password: process.env.HUBOT_FLOWDOCK_LOGIN_PASSWORD

    bot = new flowdock.Session(options.login_email, options.login_password)
    bot.fetchFlows((flows) =>
      flows.forEach (flow) =>
        bot.fetchUsers(flow.organization.subdomain, flow.slug, (users) =>
          users.forEach (flow_user) =>
            return if flow_user.user.disabled == true
            user =
              id: flow_user.user.id
              name: flow_user.user.nick
            @userForId(user.id, user)
        )
        bot.subscribe(flow.organization.subdomain, flow.slug)
    )

    bot.on "message", (message) =>
      return unless message.event == 'message'
      flow = bot.flows.filter((flow) -> return flow.name == message.flow)[0]
      author = @userForId(message.user)
      return if @name == author.name
      author.flow = flow
      @receive new Robot.TextMessage(author, message.content)

    @bot = bot

module.exports = Flowdock

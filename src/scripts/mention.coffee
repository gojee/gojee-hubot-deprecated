# the horror!
address_book =
  'goran':     'goran.svorcan@gojee.com',
  'nick':      'nick.della.valle@gojee.com',
  'pete':      'pete.zimbelman@gojee.com',
  'muffin':    'pete.zimbelman@gojee.com',
  'ricky':     'ricky.cheng@gojee.com'
  'thomas':    'thomas.symborski@gojee.com',
  'gruffalo':  'thomas.symborski@gojee.com',
  'tian':      'tian.he@gojee.com',
  'travis':    'travis.sheppard@gojee.com',

module.exports = (robot) ->

  robot.hear /@(\w+)/gi, (msg) ->
    @current_user = msg.message.user.name
    @message = msg.message.text
    @room_id = msg.message.user.room

    # who hardcoded authentications!?!?!? :cat2:
    transport = require('nodemailer').createTransport 'SMTP',
      service: 'Gmail',
      auth:
        user: 'meowgojee@gmail.com',
        pass: 'meowgojee'


    for user in msg.match
      @mentioned_user = user.slice(1)
      @email = address_book[@mentioned_user]

      mailOptions =
          from: 'no-reply@gojaa.com',
          to: @email,
          subject: "#{@current_user} mentioned you in Campfire [Gojee]"
          html: "Hi #{@mentioned_user.charAt(0).toUpperCase()}#{@mentioned_user.slice(1)},
            <p>#{@current_user} just mentioned you in the room [Tornado].</p>
            <b>#{@current_user}:</b> #{@message}"

      transport.sendMail(mailOptions)

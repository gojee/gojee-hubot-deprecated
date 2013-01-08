sounds = ['secret', 'trombone', 'crickets', 'rimshot', 'vuvuzela',
  'tmyk', 'live', 'drama', 'yeah', 'greatjob', 'pushit', 'nyan', 'tada',
  'ohmy', 'bueller', 'ohyeah', '56k', 'dangerzone', 'horn', 'horror',
  'loggins', 'yodel', 'sax', 'noooo', 'heygirl', 'inconceivable',
  'deeper', 'whoomp', 'clowntown', 'what', 'bezos', 'trololo',
  'sexyback']


module.exports = (robot) ->

  robot.hear /nicki/ig, (msg) ->
    msg.send "/play #{sounds[parseInt(sounds.length*Math.random())]}"

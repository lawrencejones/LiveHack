window.initialise_clock = (end_time) ->
  setInterval (->
    timeLeft = new Date(end_time - (new Date()).getTime())
    $("#year_header").html timeLeft
    hourDifference = timeLeft.getHours()
    minuteDifference = timeLeft.getMinutes()

    secondDifference = timeLeft.getSeconds()
    timeCase = 0
    if hourDifference > 0
      timeCase = 2
    else if minuteDifference > 0
      timeCase = 1
    else
      timeCase = 0
    if timeCase >= 2
      $("#hour_header").html "hours"
      $("#hour11").html Math.floor(hourDifference / 10)
      $("#hour21").html hourDifference % 10
    if timeCase >= 1
      $("#minute_header").html "minutes"
      $("#minute11").html Math.floor(minuteDifference / 10)
      $("#minute21").html minuteDifference % 10
    
    $("#second_header").html "seconds"
    $("#second11").html Math.floor(secondDifference / 10)
    $("#second21").html secondDifference % 10
  ), 1000
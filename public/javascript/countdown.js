
	var finishTime = 1367161200000;
	var currentTime;
	$(document).ready(function () {
		setInterval(function() {
			timeLeft = new Date(finishTime - (new Date()).getTime());
            $("#year_header").html(timeLeft);
			var yearDifference = timeLeft.getFullYear() - 1970;
			var monthDifference = timeLeft.getMonth()-1;
			var dayDifference = timeLeft.getDate()-1;
            var hourDifference = timeLeft.getHours();
			var minuteDifference = timeLeft.getMinutes();
			var secondDifference = timeLeft.getSeconds();
			var timeCase = 0;
          //  $("#year_header").html(currentTime);  
            //$("#year").html(finishTime.getSeconds());        

			if( yearDifference > 0 ) {
				timeCase = 5;
			} else if( monthDifference > 0 ) {
				timeCase = 4;
			} else if( dayDifference > 0 ) {
				timeCase = 3;
			} else if( hourDifference > 0 ) {
				timeCase = 2;
			} else if( minuteDifference > 0 ) {
				timeCase = 1;
			}
			switch( timeCase ) {
				case 5:
					$("#year_header").html("years");
					$("#year").html(yearDifference);
				case 4:
					$("#month_header").html("months");
					$("#month").html(monthDifference);
				case 3:
					$("#day_header").html("days");
					$("#day").html(dayDifference);
				case 2:
					$("#hour_header").html("hours");
					$("#hour").html(hourDifference);
				case 1:
					$("#minute_header").html("minutes");
					$("#minute").html(minuteDifference);
				default:
					$("#second_header").html("seconds");
					$("#seconds").html(secondDifference);
            }
		}, 1000);
	});
// 	function test() {
// 	window.timer = new CountDownTimer("#countdown")
// }
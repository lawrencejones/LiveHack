window.initialise_buddy_match = function() {
	$.getJSON("http://livehack-facebook.herokuapp.com/buddy_data.json", function(data) {
	    var i = 0;
		$.each(data, function(obj) {
			if(obj.isIdea) {
				$("#ideas").append('<tr><td>obj.name</td><td>obj.idea</td><td>obj.skills_req</td>'
					+'<td><div class="fb-comments" data-href="http://livehack-facebook.herokuapp.com/buddy'+i+'" data-num-posts="3"> </div></td></tr>');
			} else {
				$("#skills").append('<tr><td>obj.name</td><td>obj.skills</td>'
					+'<td><div class="fb-comments" data-href="http://livehack-facebook.herokuapp.com/buddy'+i+'" data-num-posts="3"> </div></td></tr>');
			}
			i++;
		});
		
	});
}

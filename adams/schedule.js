window.initialise_schedule = function() {
	google.load("visualization", "1");
	google.setOnLoadCallback(drawTimeline);
	function drawTimeline() {
        console.log("success");
		var dataTable = new google.visualization.DataTable();
		dataTable.addColumn('string', 'icon');
		dataTable.addColumn('boolean', 'isMajor');
		dataTable.addColumn('string', 'content');
		dataTable.addColumn('datetime', 'start');
		$.each(window.hackathon.scheduleItems, function(i, obj) {
			var datum = [];
			var i = 0;
			$.each(obj, function(key, value) {
				if(i == 5) {
					datum.push(new Date(parseInt(value)));
				}else if( i != 0 && i != 2 && i != 6 ) {
					datum.push(value);
				}
				i++;
			});
			dataTable.addRow(datum);
		});

		var options = {
			"width": "100%", 
			"height": "300px", 
			"style": "box",
			"axisOnTop": true,
			"start": new Date(1367082000000),
			"end": new Date(1367082000000),
		}

		var timeline = new links.Timeline(document.getElementById('schedule'));
		timeline.draw(dataTable, options);
	}
}
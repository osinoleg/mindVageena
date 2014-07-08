var elapsedTime;
var timerCounter;
var pollResponse;

function pollTimer()
{
	elapsedTime += 1;
	if(false) // insert condition here
	{
		clearInterval(timerCounter);
     	//counter ended, do something here
     	return;
 	}

 	$.get( "/poll_mind_data", function( response ) {
	    // console.log( "test" + response ); // server response
	    pollResponse = response;
	});
}

function pollMindData()
{
	clearInterval(timerCounter);
	elapsedTime = 0;
	timerCounter = setInterval(pollTimer, 1000); //1000 will run it every 1 second
}


function beginMindGraph()
{
	pollMindData();
	graphMindData("#attention");
	graphMindData("#meditation");
}

function graphMindData(id)
{
	var width = Math.max(200, 400),
    height = Math.max(200, 220);

	var x1 = width / 2,
	    y1 = height / 2,
	    x0 = x1,
	    y0 = y1,
	    i = 0,
	    r = 100,
	    τ = 2 * Math.PI;

	var mindDelta = r;

	var canvas = d3.select(id).append("canvas")
	    .attr("width", width)
	    .attr("height", height)
	    

	var context = canvas.node().getContext("2d");
	context.globalCompositeOperation = "lighter";
	context.lineWidth = 2;

	d3.timer(function() {

		// $.get( "/poll_mind_data", function( response ) {
		//  //    console.log( "test" + response ); // server response
		    
		//  //    if(id == "#attention")
		// 	//     mindDelta = response.attention;
		// 	// else 
		// 	// 	mindDelta = response.meditation;
		// });

		if(pollResponse)
		{
		    if(id == "#attention")
			    mindDelta = pollResponse.attention;
			else 
				mindDelta = pollResponse.meditation;
		}
	
		if(mindDelta > r)
			r++;
		else if(mindDelta < r)
			r--;

		context.clearRect(0, 0, width, height);

		var z = d3.hsl(++i % 360, 1, .5).rgb(),
			c = "rgba(" + z.r + "," + z.g + "," + z.b + ",",
			x = x0 += (x1 - x0) * .1,
			y = y0 += (y1 - y0) * .1;

		d3.select({}).transition()
			.duration(2000)
			.ease(Math.sqrt)
			.tween("circle", function() {
				return function(t) {
					context.strokeStyle = c + (1 - t) + ")";
					context.beginPath();
					context.arc(x, y, r * t, 0, τ);
					context.stroke();
		    	};
		  	});
	} );
}


var elapsedTime;
var timerCounter;

function mindTimer()
{
	elapsedTime += 1;
	if(false) // insert condition here
	{
		clearInterval(timerCounter);
     	//counter ended, do something here
     	return;
 	}

 	$.get( "/poll_mind_data", function( response ) {
	    console.log( "test" + response ); // server response
	    
	    console.log(response.attention);

	    var data = [response.attention, response.meditation];

	    // update bar graph (if elements already exist)
		d3.select(".chart")
		  .selectAll("div")
		    .data(data)
		    .transition()
		    .duration(3200)
		    .style("width", function(d) { return d * 10 + "px"; })
		    .text(function(d) { return d; });

		d3.select(".chart")
		  .selectAll("div")
		    .data(data)
		  .enter().append("div") // only does this if no div exists
		    .style("width", function(d) { return d * 10 + "px"; })
		    .text(function(d) { return d; });

	});
}

function graphMind()
{
	clearInterval(timerCounter);
	elapsedTime = 0;
	timerCounter = setInterval(mindTimer, 3000); //1000 will run it every 1 second
}

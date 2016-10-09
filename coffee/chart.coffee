# retrieve data from fireBase
firebaseRef = firebase.database().ref('/items');
firebaseRef.orderByChild('gender').once('value')
  .then (snapshot) ->
    # calculate numbers
    # init
    mf_numbers = [{
      'gender':'male',
      'value':0},
      {'gender':'female',
      'value':0}
    ]
    pyramid_m = []
    pyramid_f = []
    for i in [100 - 1..0] by -1
      pyramid_m.push {'age':i+1, value:0}
      pyramid_f.push {'age':i+1, value:0}

    # count numbers
    snapshot.forEach (child) ->
      if child.val()['gender'] == 'Male'
        mf_numbers[0]['value'] += 1
        for item,index in pyramid_m when item['age'] == child.val()['age']
          pyramid_m[index]['value'] += 1
        console.log(child.val())
      else if child.val()['gender'] == 'Female'
        mf_numbers[1]['value'] += 1
        for item,index in pyramid_f when item['age'] == child.val()['age']
          pyramid_f[index]['value'] += 1
        console.log(child.val())
    # update Male/Female chart
    updateMFChart(mf_numbers)
    maxval = d3.max(pyramid_f.concat(pyramid_m), (d)-> d.value )
    # update population pyramid
    updatePyramid(pyramid_f, maxval, 'female')
    updatePyramid(pyramid_m, maxval, 'male')

# svg initial values
svgW = 600
svgH = 200
svgW2 = 300
svgH2 = 500
yMargin = 50
xMargin = 60
xMargin2 = 80

# update pyramid chart
updatePyramid = (dataSet, maxval, type) ->
  svg = svgr
  fill = 'red'
  marginLeft = xMargin2
  xfunc = marginLeft
  axscale = d3.scale.linear()
  .domain([0, maxval])
  .range([0, svgW2]);
  if (type == 'male')
    fill = 'blue'
    svg = svgl
    xfunc = (d) -> svgW2 - scale(d.value)
    axscale = d3.scale.linear()
    .domain([0, maxval])
    .range([svgW2, 0]);
    marginLeft = 0

  scale = d3.scale.linear()
  .domain([0, maxval])
  .range([0, svgW2]);

  # draw chart
  barchart = svg.selectAll('rect')
	 .data(dataSet)
	 .enter()
	 .append('rect')
	 .attr({
	 	x: xfunc,
	 	y: (d, i)-> i * 4 + yMargin,
	 	width: (d)-> scale(d.value) ,
	 	height: 2,
	 	fill: fill
	 });

  xAxisCall = d3.svg.axis()
	  .scale(axscale)
	  .orient('bottom')

  xAxis = svg.append('g')
	 .attr({
		   "class": "axis",
		   "transform": "translate(" + [marginLeft, 0] + ")",
	   })
	    .call(xAxisCall);

  # draw axis
  if (type == 'female')
    for i in [11 - 1..0] by -1
      svg.append("text")
        .attr("x", 40 )
        .attr("width", 100)
        .attr("y", (400 + yMargin) - (i * 41) )
        .style("text-anchor", "middle")
        .text(i * 10);


# update Male/Female chart
updateMFChart = (dataSet) ->
  console.log('##updatechart')
  # scale
  scale = d3.scale.linear()
  .domain([0, d3.max(dataSet, (d)-> d.value )])
  .range([0, svgW - xMargin]);

  barchart = svg.selectAll('rect')
	 .data(dataSet)
	 .enter()
	 .append('rect')
	 .attr({
	 	x: xMargin,
	 	y: (d, i)-> i * 30 + yMargin,
	 	width: (d)-> scale(d.value) ,
	 	height: 20,
	 	fill: "blue"
	 });

  xAxisCall = d3.svg.axis()
	  .scale(scale)
	  .orient('bottom')

  xAxis = svg.append('g')
	 .attr({
		   "class": "axis",
		   "transform": "translate(" + [xMargin, 0] + ")"
	   })
	    .call(xAxisCall);

  svg.append("text")
    .attr("x", 10 )
    .attr("y", 65)
    .text("男性");

  svg.append("text")
    .attr("x", 10 )
    .attr("y", 95)
    .text("女性");

# define svg area
svg= d3.select("#graphContainer").append("svg")
  .attr("width", svgW)
  .attr("height", svgH)
d3.select("#graphContainer").append("div")
svgl= d3.select("#graphContainer").append("svg")
  .attr("width", svgW2)
  .attr("height", svgH2)
  .style('margin-left', 20)
svgr= d3.select("#graphContainer").append("svg")
  .attr("width", svgW2 + xMargin2)
  .attr("height", svgH2)

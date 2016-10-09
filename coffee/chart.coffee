firebaseRef = firebase.database().ref('/items');
firebaseRef.orderByChild('gender').once('value')
  .then (snapshot) ->
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
    updateMFChart(mf_numbers)
    maxval = d3.max(pyramid_f.concat(pyramid_m), (d)-> d.value )
    console.log(maxval)
    updatePyramid(pyramid_f, maxval, 'female')
    updatePyramid(pyramid_m, maxval, 'male')

svgW = 600
svgH = 200
svgW2 = 300
svgH2 = 500
yMargin = 50
xMargin = 60

updatePyramid = (dataSet, maxval, type) ->
  svg = svgr
  fill = 'red'
  xfunc = 0
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

  scale = d3.scale.linear()
  .domain([0, maxval])
  .range([0, svgW2]);

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
		   "transform": "translate(" + [0, 0] + ")"
	   })
	    .call(xAxisCall);


updateMFChart = (dataSet) ->
  console.log('##updatechart')
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

svg= d3.select("body").append("svg")
  .attr("width", svgW)
  .attr("height", svgH)
d3.select("body").append("div")
svgl= d3.select("body").append("svg")
  .attr("width", svgW2)
  .attr("height", svgH2)
svgr= d3.select("body").append("svg")
  .attr("width", svgW2)
  .attr("height", svgH2)
  .style('margin-left', 20)

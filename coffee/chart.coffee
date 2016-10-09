firebaseRef = firebase.database().ref('/items');
firebaseRef.orderByChild('gender').once('value')
  .then (snapshot) ->
    mf_numbers = [{
      'gender':'male',
      'value':0},
      {'gender':'female',
      'value':0}
    ]
    snapshot.forEach (child) ->
      console.log(child.val())
      if child.val()['gender'] == 'Male'
        mf_numbers[0]['value'] += 1
        console.log(child.val())
      else if child.val()['gender'] == 'Female'
        mf_numbers[1]['value'] += 1
        console.log(child.val())
    updateMFChart(mf_numbers)

svgW = 300
svgH = 200
yMargin = 50
xMargin = 10

updateMFChart = (dataSet) ->
  console.log('##updatechart')
  console.log(dataSet)
  scale = d3.scale.linear()
  .domain([0, d3.max(dataSet, (d)-> d.value )])
  .range([0, svgH]);

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

svg= d3.select("body").append("svg")
  .attr("width", svgW)
  .attr("height", svgH)

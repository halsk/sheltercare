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
        for item in pyramid_f when item['age'] == child.val()['age']
          item['value'] = +1
        console.log(child.val()['age'])
    console.log(pyramid_m)
    updateMFChart(mf_numbers)

svgW = 300
svgH = 200
svgW2 = 300
svgH2 = 200
yMargin = 50
xMargin = 60

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
  .style('background-color','gray')
svgr= d3.select("body").append("svg")
  .attr("width", svgW2)
  .attr("height", svgH2)
  .style('background-color','red')

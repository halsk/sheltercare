firebaseRef = firebase.database().ref('/items');
firebaseRef.orderByChild('gender').once('value')
  .then (snapshot) ->
    updateChart(snapshot.exportVal())
    mf_numbers = [0,0]
    snapshot.forEach (child) ->
      if child.val()['gender'] == 'Male'
        mf_numbers[0] += 1
      else if child.val()['gender'] == 'Female'
        mf_numbers[1] += 1
      console.log(child.val())
    console.log(mf_numbers)

updateChart = (data) ->
  console.log('##updatechart')
  console.log(data)

theData = [ 1, 2, 3 ]
p = d3.select("body").selectAll("p.data")
  .data(theData)
  .enter()
  .append("p")
  .text (d) ->
    d;

circleRadii = [40, 20, 10];
svgContainer = d3.select("body").append("svg")
  .attr("width", 200)
  .attr("height", 200)
  .style("border", "1px solid black");

circles = svgContainer.selectAll("circle")
  .data(circleRadii)
  .enter()
  .append("circle");

circleAttributes = circles
  .attr("cx", 50)
  .attr("cy", 50)
  .attr("r", (d) -> d )
  .style("fill", (d) ->
    returnColor
    if (d == 40)
       returnColor = "green";
    else if (d == 20)
       returnColor = "purple";
    else if (d == 10)
       returnColor = "red";
    returnColor)

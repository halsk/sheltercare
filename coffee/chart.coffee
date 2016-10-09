firebaseRef = firebase.database().ref('/items');
firebaseRef.on 'child_added', (snapshot) ->
  console.log(snapshot);
theData = [ 1, 2, 3 ]
p = d3.select("body").selectAll("p")
  .data(theData)
  .enter()
  .append("p")
  .text("hello ");

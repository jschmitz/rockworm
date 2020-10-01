import * as d3 from "d3"
import getWeek from 'date-fns/getWeek'

export function paint() {
  // set the dimensions and margins of the graph
  var margin = {top: 30, right: 30, bottom: 30, left: 70},
    width = 450 - margin.left - margin.right,
    height = 450 - margin.top - margin.bottom;

  // append the svg object to the body of the page
  var svg = d3.select("#my_dataviz")
  .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");


  // Labels of row and columns
  const startWeek = 32
  let today = new Date();
  let weeksOfYear = [];

  for (let i = startWeek; i <= getWeek(today); i++) {
    weeksOfYear.push(i);
  }
  var daysOfWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

  // Build X scales and axis:
  var x = d3.scaleBand()
    .range([ 0, width ])
    .domain(weeksOfYear)
    .padding(0.01);
  svg.append("g")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x))

  // Build X scales and axis:
  var y = d3.scaleBand()
    .range([ height, 0 ])
    .domain(daysOfWeek)
    .padding(0.01);
  svg.append("g")
    .call(d3.axisLeft(y));

  // Build color scale
  var myColor = d3.scaleLinear()
    .range(["white", "#69b3a2"])
    .domain([1,10])

  //Read the data
  d3.json("/workout_logs.json")
    .then(function(data) {

      for(let i = 0; i < data.length; i++){

        // create a tooltip
        var tooltip = d3.select("#my_dataviz")
          .append("div")
          .style("opacity", 0)
          .attr("class", "tooltip")
          .style("background-color", "white")
          .style("border", "solid")
          .style("border-width", "2px")
          .style("border-radius", "5px")
          .style("padding", "5px")
          .style("display", "none")


        // Three function that change the tooltip when user hover / move / leave a cell
        var mouseover = function(d) {
          tooltip.style("opacity", 1)
          .style("display", "inline")
          .style("position", "absolute")
        }

        var mousemove = function(d) {
          tooltip
            .html("The exact value of<br>this cell is: " + data[i].notes)
            .style("left", (d.screenX + 20) + "px")
            .style("top", (d.screenY - 120) + "px")
        }

        var mouseleave = function(d) {
          tooltip.style("opacity", 0)
        }

        let workout = [data[i]]
        svg.selectAll()
            .data(workout, function(d) { return d.week_of_year+':'+d.day_of_week; })
            .enter()
            .append("rect")
            .attr("x", function(d) { return x(d.week_of_year) })
            .attr("y", function(d) { return y(d.day_of_week) })
            .attr("width", x.bandwidth() )
            .attr("height", y.bandwidth() )
            .style("fill", function(d) { return myColor(d.intensity)} )
            .on("mouseover", mouseover)
            .on("mousemove", mousemove)
            .on("mouseleave", mouseleave)
      }

      })
    .catch(function(error){
      console.log(error)
    });
}

document.addEventListener("turbolinks:load", function() {
  paint();
});

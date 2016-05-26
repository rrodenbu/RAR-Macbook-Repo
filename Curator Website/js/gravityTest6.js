window.onload=function(){
    var margin = {
        top: 0,
        right: 0,
        bottom: 0,
        left: 0
    },
    width = window.innerWidth,
    height = window.innerHeight;

    var n = 10, //number of balls
        m = 1, //number of nodes *diffrent types of balls*
        padding = 0,
        radius = d3.scale.sqrt().range([0, 12]),
        color = d3.scale.category10().domain(d3.range(m)),
        x = d3.scale.ordinal().domain(d3.range(m)).rangePoints([0, width], 1);

    var nodes = d3.range(n,20).map(function () {
        var i = Math.floor(Math.random() * m), //color
            v = (i + 1) / m * -Math.log(Math.random()); //value
        return {
            radius: radius(v),
            color: color(i),
            cx: x(i),
            cy: height / 2,
        };

    });

    var force = d3.layout.force()
        .nodes(nodes)
        .size([width, height])
        .gravity(9)
        .charge(0)
        .on("tick", tick)
        .start();

    var svg = d3.select("#chart").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var circle = svg.selectAll("circle")
        .data(nodes)
        .enter().append("circle")
        .attr("r", function (d) {
            return d.radius;
        })
        .style("fill", function (d) {
            return d.color;
        })
        
        .call(force.drag)
        .on("click", function(){//http://stackoverflow.com/questions/9080862/d3-js-adding-click-action-to-a-force-layout-circle
            d3.select(this)
            .style("fill","red")
            .transition()
            .duration(750)
            .delay(function(d, i) { return i * 5; })
            .attrTween("r", function(d) {
                var i = d3.interpolate(d.radius, d.radius+30);
                return function(t) { return d.radius = i(t); };
                collide(.5);
                d.radius = d.radius+30;
            });
        })
        .on("dblclick", function(){//http://stackoverflow.com/questions/9080862/d3-js-adding-click-action-to-a-force-layout-circle
            d3.select(this)
            .style("fill","red")
            .transition()
            .duration(750)
            .delay(function(d, i) { return i * 5; })
            .attrTween("r", function(d) {
                var i = d3.interpolate(d.radius, 0);
                return function(t) { return d.radius = i(t); };
                collide(.5);
                d.radius = d.radius+30;
            });
        })

    function tick(e) {
        circle.each(gravity(.2 * e.alpha))
            .each(collide(.5))
            .attr("cx", function (d) {
            return d.x;
        })
            .attr("cy", function (d) {
            return d.y;
        });
    }

    // Move nodes toward cluster focus.
    function gravity(alpha) {
        return function (d) {
            d.y += (d.cy - d.y) * alpha;
            d.x += (d.cx - d.x) * alpha;
        };
    }

    // Resolve collisions between nodes.
    function collide(alpha) {
        var quadtree = d3.geom.quadtree(nodes);
        return function (d) {
            var r = d.radius + radius.domain()[1] + padding,
                nx1 = d.x - r,
                nx2 = d.x + r,
                ny1 = d.y - r,
                ny2 = d.y + r;
            quadtree.visit(function (quad, x1, y1, x2, y2) {
                if (quad.point && (quad.point !== d)) {
                    var x = d.x - quad.point.x,
                        y = d.y - quad.point.y,
                        l = Math.sqrt(x * x + y * y),
                        r = d.radius + quad.point.radius + (d.color !== quad.point.color) * padding;
                    if (l < r) {
                        l = (l - r) / l * alpha;
                        d.x -= x *= l;
                        d.y -= y *= l;
                        quad.point.x += x;
                        quad.point.y += y;
                    }
                }
                return x1 > nx2 || x2 < nx1 || y1 > ny2 || y2 < ny1;
            });
        };
    }
    }//]]> 
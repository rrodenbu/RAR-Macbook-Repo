window.onload=function(){
    
    //Set Size of window balls are in
    width = window.innerWidth;     //set to width of browser window
    height = window.innerHeight/2; //set to height/2 of browser window
    
    var ballCount = 8; //number of balls on the screen
    var radius = d3.scale.sqrt.range([30,50]) //radius of balls (random)
    //var colorOfBall = 255; //color of balls
    var xCoord = d3.scale.ordinal().domain(d3.range(m)).rangePoints([0, width], 5); //Have the balls collect in the center of the screen DN?
    
    //For each node (type of ball) it assigns it properties
    //creates an "array" of nodes in variable nodes
    var nodes = d3.range(ballCount).map(function(){
        var i = Math.floor(Math.random() * m), //color
        var v = (i + 1) / m * -Math.log(Math.random()); //value
        return {
            radius: radius(v), //radius of balls
            color: 255, //color of balls
            cx: width/2,
            cy: height / 2,
        };
    })
    
    
    var force = d3.layout.force()
                         .nodes(nodes)
                         .size([-1700, 1]) //assigns center of gravity
                         .friction([0.9])  //Default, rate it slows motion
                         .charge()
}





















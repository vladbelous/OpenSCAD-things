
module line(p1, p2) {
    hull() {
        translate(p1) circle(r=5, $fn=16); 
        translate(p2) circle(r=5, $fn=16); 
    }
}

module hexagonify() {
    children(0);
    for (a = [0:60:300]) {
        rotate(a) children(0);
    }
}

module hex_gridify() {
    for (i = [0:5], j = [0:5]) {
        s = sqrt(3)/2;
        yp = sin(30) + 1;
        translate([100 * (i * 2*s + (j%2) * s), 100 * yp*j])
            children(0);
    }
}

%hexagonify()
    polygon([ [0, 0], [0, 100], [100*sin(60), 100*cos(60)] ]);

module pattern() {
    line([20*cos(30), 20*sin(30)], [0,20]);
    line([0,20], [0, 40]);
    line([0,40], [20, 60]);
    line([20,60], [40, 60]);
    line([40,60], [60, 50]);
    line([60,50], [100*cos(30), 100*sin(30)]);
}

module smooth() {
    offset(r=-5) offset(delta=+5)
        offset(r=+4.5) offset(delta=-4.5)
            children(0);
}

linear_extrude(3) hex_gridify()
    hexagonify() smooth() pattern();
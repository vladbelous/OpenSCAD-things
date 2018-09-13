WallWidth = 1.0;
GapWidth = 1.0;

// Two-dimensional line between p1 and p2.
module line(p1, p2) {
    hull() {
        translate(p1) circle(WallWidth/2, $fn=4);
        translate(p2) circle(WallWidth/2, $fn=4);
    }
}

BaseOffset = WallWidth / 2 + GapWidth + WallWidth / 2; 

// Simple curve that connects diagonally within a square [-2*s, 2*s].
module Scurve() {
    s = BaseOffset;
    union() {
        line([-2*s,-2*s], [-2*s, 2*s]);
        line([-2*s, 2*s], [   s, 2*s]);
        line([   s, 2*s], [   s,  -s]);
        line([   s,  -s], [   0,  -s]);
        line([   0,  -s], [   0,   s]);
        
        line([   0,   s], [  -s,   s]);
        line([  -s,   s], [  -s,-2*s]);
        line([  -s,-2*s], [ 2*s,-2*s]);
        line([ 2*s,-2*s], [ 2*s, 2*s]);
    }
}


Pitch = 5*WallWidth + 5*GapWidth;

// Arbitrary long curve formed by connecting multiple scurves. 
module Curve() {
    for (j = [0:6]) {
        for (i = [0:6]) {
            translate([j*Pitch, i*Pitch])
                rotate(90 * (i%2 + j%2)) Scurve();
        }
    }
}

// Small side connector between scurve squares.
// Primary purpose is to make the complete curve such that
// it could be printed without travel (at least initial layer).
module SideConnectors() {
    for (j = [0:2:5])
        translate([0, (j+1)*Pitch + Pitch/2])
            line([0, -GapWidth], [0, GapWidth]);
 
}
module Connectors() {
    // Inner x-type connectors
    for (j = [0:2:5])
        for (i = [0:2:5]) {
            translate([j*Pitch, i*Pitch]) union() {
                z = BaseOffset;
                line([2*z,2*z], [3*z,3*z]);
                line([2*z,3*z], [3*z,2*z]);
            }
            translate([(j+1)*Pitch, (i+1)*Pitch]) union() {
                z = BaseOffset;
                line([2*z,2*z], [3*z,3*z]);
                line([2*z,3*z], [3*z,2*z]);
            }
        }
    
    // Add all side connections
    translate([-2*BaseOffset, 0])
        SideConnectors();
    translate([0, -2*BaseOffset])
        rotate(-90) SideConnectors();
    translate([+2*BaseOffset + (5+1)*Pitch, -Pitch])
        SideConnectors();
    translate([-Pitch, (5+1)*Pitch+2*BaseOffset])
        rotate(-90) SideConnectors();

}

union() {
    linear_extrude(2) Curve();
    linear_extrude(1) Connectors();
}

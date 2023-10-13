// Adapterring
use <2dWedge.scad>

// Resolution for 3D printing:
$fa = 1;
$fs = 0.4;

// Allgemeines:
delta = 0.10; // Standard Durchdringung

// Körper 1 -- k1 -- Unterer Ring
k1_d_innen   = 124.50; // Innendurchmesser
k1_wanddicke =   4.25; // Wanddicke
k1_d_aussen  = k1_d_innen + 2 * k1_wanddicke;
k1_h         =  25.00; // Höhe

module k1() {
    difference() {
        cylinder(h = k1_h, d = k1_d_aussen);
        translate([0, 0, -delta])
            cylinder(h = k1_h + 2*delta,
                     d = k1_d_innen);
    }
}

// Körper 2 -- k2 -- Mittlerer Ring
k2_d_innen   = 110.00; // Innendurchmesser
k2_h         =   2.00; // Höhe

module k2() {
    difference() {
        cylinder(h = k2_h, d = k1_d_aussen);
        translate([0, 0, -delta])
            cylinder(h = k2_h + 2*delta,
                     d = k2_d_innen);
    }
}

// Körper 3 -- k3 -- Oberer Ring
k3_d_aussen  = 128.00; // Außendurchmesser
k3_wanddicke =   3.50; // Wanddicke
k3_d_innen   = k3_d_aussen - 2 * k3_wanddicke;
k3_h         =   7.00; // Höhe

module k3() {
    difference() {
        cylinder(h = k3_h + delta, d = k3_d_aussen);
        translate([0, 0, -delta])
            cylinder(h = k3_h + 3*delta,
                     d = k3_d_innen);
    }
}

// Gewinde -- gw
gw_d_aussen  = k1_d_innen + 2*delta;
gw_d_innen   = 114.00; // Innendurchmesser
gw_h         =   1.60; // Höhe
gw_winkel    = 110;
gw__size     =  10.00; // Plättchen zum Abschrägen

// Plaettchen zum Abschrägen der Gewindeenden
module plaettchen() {
    rotate([0, 0, 45])
        translate([-gw__size/2, -gw__size/2, -delta])
            cube([gw__size, gw__size, gw_h + 2*delta]);
}

module _gw() {
    rotate([5, 0, -gw_winkel/2]) {
        difference() {
            linear_extrude(height = gw_h) {
                2dWedge(gw_d_aussen / 2.0, 0,
                        gw_winkel);
            }
            {
                translate([0, 0, -delta])
                    cylinder(h = gw_h + 2*delta,
                             d = gw_d_innen);
                translate([gw_d_innen / 2.0 * 0.95, 
                            0, 0])
                    plaettchen();
                rotate([0, 0, gw_winkel])
                    translate([gw_d_innen / 
                                2.0 * 0.95, 0, 0])
                        plaettchen();
                }
        }
    }
}

module gw() {
    _gw();
    rotate([0, 0, 180])
        _gw();
}

module k() {
    k1();
    translate([0, 0, k1_h - k2_h])
        k2();
    translate([0, 0, k1_h - delta])
        k3();
    gw();
}

//k1();
//k2();
//k3();
//_gw();
//gw();
k();

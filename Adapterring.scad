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



module k() {
    k1();
    translate([0, 0, k1_h - k2_h])
        k2();
    translate([0, 0, k1_h - delta])
        k3();
}

//k1();
//k2();
//k3();
//k();

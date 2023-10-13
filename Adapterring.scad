// Adapterring

// Resolution for 3D printing:
$fa = 1;
$fs = 0.4;

// Allgemeines:
delta = 0.10; // Standard Durchdringung

// Körper 1 -- k1
k1_d_innen   = 124.50; // Innendurchmesser
k1_wanddicke =   4.25; // Wanddicke
k1_d_aussen  = k1_d_innen + 2 * k1_wanddicke;
k1_h         =  25.00;

module k1() {
    difference() {
        cylinder(h = k1_h, d = k1_d_aussen);
        translate([0, 0, -delta])
            cylinder(h = k1_h + 2*delta,
                     d = k1_d_innen);
    }
}

k1();

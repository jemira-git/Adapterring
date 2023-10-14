// Adapterring

// Resolution for 3D printing:
$fa = 1;
$fs = 0.4;

use <./2dWedge.scad>

// Allgemeines:
delta = 0.10; // Standard Durchdringung

// Taschen -- ta -- Taschen zum Einrasten
ta_breite   = 17.00;
ta_hoehe    =  7.00;
ta_tiefe    =  1.50;

module _tasche() {
    umfang = k1_d_innen * PI;
    grad = (ta_breite / umfang) * 360;
    linear_extrude(height = ta_hoehe) {
        2dWedge(k1_d_innen / 2.0 + ta_tiefe,
                0, grad);
    }
}

// Brauche Gewinde Offsets schon hier
gw_offset1   =  14.60; // Von Unterkante von k1
gw_offset2   =  15.70; // Von Unterkante von k1
gw_h         =   1.60; // Höhe

module taschen() {
    translate([0, 0, gw_offset1 - ta_hoehe + gw_h]) {
        _tasche();
        rotate([0, 0, 90])
            _tasche();
        rotate([0, 0, 180])
            _tasche();
        rotate([0, 0, 270])
            _tasche();
    }
}

// Körper 1 -- k1 -- Unterer Ring
k1_d_innen   = 124.50; // Innendurchmesser
k1_wanddicke =   4.25; // Wanddicke
k1_d_aussen  = k1_d_innen + 2 * k1_wanddicke;
k1_h         =  25.00; // Höhe

module k1() {
    difference() {
        cylinder(h = k1_h, d = k1_d_aussen);
        {
            translate([0, 0, -delta])
                cylinder(h = k1_h + 2*delta,
                         d = k1_d_innen);
            taschen();
        }
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

// Forward k3

// Gewinde -- gw
gw_d_aussen  = k1_d_innen + 2*delta;
gw_d_innen   = 114.00; // Innendurchmesser
gw_winkel    = 110;    // Grad Gewindesegmente
gw__size     =  10.00; // Plättchen zum Abschrägen
gw_kipp      =   2;    // Grad Kippwikel

// Plaettchen zum Abschrägen der Gewindeenden
module plaettchen() {
    rotate([0, 0, 45])
        translate([-gw__size/2, -gw__size/2, -delta])
            cube([gw__size, gw__size, gw_h + 2*delta]);
}

module _gw() {
    rotate([gw_kipp, 0, -gw_winkel/2]) {
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
    translate([0, 0, gw_offset1])
        _gw();
    translate([0, 0, gw_offset2])
        rotate([0, 0, 180])
            _gw();
}

// Clips -- cl
// Alle Werte normiert auf 1.0:
cl_sin_amplitude = 0.110; // Stärke des Sinus
cl_thickness     = 0.200; // Dicke des Sinus
cl_left          = 1.250; // Platz nach links
cl_bottom        = 0.235; // Platz nach unten
cl_d_knubbel     = 0.175; // Durchmesser des Knubbels
cl_x_knubbel     = 0.500; // Knubbel X Koordinate
cl_y_knubbel     = 0.250; // Knubbel Y Koordinate
// Skalierung auf echten Wert
cl_scale         = 10.00;

module sinus_material_2d() {
    points = [
        for (i = [0:5:360])
            [ i / 360, 
             sin(i) * cl_sin_amplitude + cl_thickness
               + cl_bottom ],
        [1.0 + cl_thickness * 1.1, 
            cl_thickness + cl_bottom],
        for (i = [360:-5:0])
            [ i / 360, 
             sin(i) * cl_sin_amplitude + cl_bottom],
        [-cl_left, cl_bottom],
        [-cl_left, 0],
        [-cl_left-cl_thickness, 0],
        [-cl_left-cl_thickness, cl_thickness 
         + cl_bottom]        
    ];
    polygon(points);
        translate([cl_x_knubbel, cl_y_knubbel])
    circle(d=cl_d_knubbel, $fn=25);
}

module clip() {
    scale([cl_scale, cl_scale, cl_scale])
        rotate([90, 0, 0])
            linear_extrude(height=1)
                sinus_material_2d();
}

// Gap -- gp1 -- Ausschnitt in k3
gp1_winkel      = 43; // Grad
gp1_h           = cl_bottom * cl_scale; // Höhe
gp1_d           = k3_d_aussen + 2*delta;
gp2_winkel      = 37; // Grad
gp2_h           = k3_h + delta;
gp2_d           = k3_d_aussen + 2*delta;
gp_korr         = 12; // Grad Winkel Korrektur

module _gp() {
    rotate([0, 0, -gp_korr])
        linear_extrude(height = gp1_h) {
            2dWedge(gp1_d / 2.0, 0, gp1_winkel);
        }
    rotate([0, 0, gp1_winkel -gp2_winkel -gp_korr])
        linear_extrude(height = gp2_h + delta) {
            2dWedge(gp2_d / 2.0, 0, gp2_winkel);
        }
}

module gp() {
    _gp();
    rotate([0, 0, 120])
        _gp();
    rotate([0, 0, 240])
        _gp();
}

module _k3_clip() {
    translate([k3_d_aussen/2 - cl_scale, 0, 0])
        rotate([0, 0, 90])
            clip();
}

module _k3_cut1() {
    difference() {
        cylinder(h = k3_h, d = k1_d_aussen);
        translate([0, 0, -delta])
            cylinder(h = k3_h + 2*delta, 
                     d = k3_d_aussen);
    }
}

module _k3_cut2() {
    cl_extra = 6.0;
    translate([0, 0, -delta])
        cylinder(h = k3_h + 2*delta, 
                 d = k3_d_innen - cl_extra);
}

module _k3_cuts() {
    _k3_cut1();
    _k3_cut2();
}

module _k3_clips() {
    _k3_clip();
    rotate([0, 0, 120])
        _k3_clip();
    rotate([0, 0, 240])
        _k3_clip();
}

module k3() {
    difference() {
        cylinder(h = k3_h + delta, d = k3_d_aussen);
        {
            translate([0, 0, -delta])
                cylinder(h = k3_h + 3*delta,
                         d = k3_d_innen);
            gp();
        }
    }
    difference() {
        _k3_clips();
        _k3_cuts();
    }
}

// Fertiger Körper -- k
module k() {
    k1();
    translate([0, 0, k1_h - k2_h])
        k2();
    translate([0, 0, k1_h - delta])
        k3();
    gw();
}

k();
//taschen();

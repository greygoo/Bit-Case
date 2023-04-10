$fn=64;

bit_length=28+1;
bit_width=4.5;
bit_shaft=20;
gap=1;
colums=7;
rows=3;
wall=2;
spacing=0.2;

inlay_width=colums*(bit_width+gap/2);
inlay_length=rows*(bit_length+gap)+gap;
inlay_height=bit_width;

case_bottom_dim=[inlay_width,inlay_height,inlay_length]
               +[2*(wall+spacing),wall+spacing,2*(wall+spacing)];
               
case_dim=case_bottom_dim+[wall+2*spacing,bit_width/2+2*wall+spacing,0];

//bit_inlay();
//case_bottom();
case_slider();

module case_slider()
{
    difference()
    {
        case_extern_top();
        translate([wall,wall,0])
        {
            cube_round(case_bottom_dim+[2*spacing-wall,bit_width/2+spacing,0],mki=3);
        }
        translate([wall/2,bit_width/2+wall,0])
        {
            cube(case_bottom_dim+[2*spacing,0,0]);
        }
        
    }
    slide_bars();
}

module case_bottom()
{
    translate([wall/2+spacing,bit_width/2+spacing+wall,0])
    {
        difference()
        {
            cube(case_bottom_dim);
            translate(-[wall/2+spacing,bit_width/2+spacing+wall,0])
            {
                #slide_bars(height=1+spacing,width=2+spacing,spacing=spacing);
            }
            translate([wall,0,wall])
            {
                cube([inlay_width+2*spacing,inlay_height+spacing,inlay_length+2*spacing]);
            }
        }
    }
    case_extern_bottom();
}

module bit_inlay()
{
    translate([wall+2*spacing+wall/2,bit_width/2+spacing+wall,wall+spacing])
    {
        difference()
        {
            cube([inlay_width,
                  inlay_height,
                  inlay_length]);
            bit_cutout();
        }
    }
}

module case_extern_top()
{
    intersection()
    {
        cube_round(case_dim,mki=4);
        cube([case_bottom_dim[0]+wall+2*spacing,
              bit_width+3*wall,
              case_bottom_dim[2]]);
    }
}

module case_extern_bottom()
{
    intersection()
    {
        difference()
        {
            cube_round(case_dim,mki=4);
            translate([wall,wall,0])
            {
                cube_round(case_bottom_dim+[2*spacing-wall,bit_width/2+spacing,0],mki=3);
            }
        }
        translate([0,bit_width+3*wall+spacing,0])
        {
            cube([case_bottom_dim[0]+wall+2*spacing,
                  inlay_height,
                  case_bottom_dim[2]]);
        }
    }
}

module slide_bars(height=1,width=2,spacing=0)
{
    translate([0,bit_width+2*wall,0])
    {
        cube([width,height,case_dim[2]-2+spacing]);
    }

    translate([case_dim[0]-width,bit_width+2*wall,0])
    {
        cube([width,height,case_dim[2]-2+spacing]);
    }
}

module bit_row()
{
    for (i = [0:colums-1])
    {
        translate([i*(bit_width+gap/2)+bit_width/2,0,0])
        {
            cylinder(d=bit_width, h=bit_shaft, $fn=6);
            translate([0,1,bit_shaft+(bit_length-bit_shaft)/2])
            {
                cube([bit_width+gap,bit_width+1,bit_length-bit_shaft], center=true);
            }
        }
    }
}

module bit_cutout()
{
    translate([0.25,0,gap])
    {
        for (i = [0:rows-1])
        {
            translate([0,0,i*(bit_length+gap)])
            {
                bit_row();
                translate([gap,bit_width/2+gap/2,0])
                {
                    cube([inlay_width-bit_width/2,3,bit_shaft-gap]);
                }
            }
        }
    }
}

module cube_round(dim,mki=5,plane="xy"){
    if(mki<=0)
    {
        cube(dim);
    }
    else
    {
        if(plane=="xy")
        {
            translate([mki/2,mki/2,0])
            {
                linear_extrude(dim[2])
                {
                    minkowski()
                    {
                        square([dim[0]-mki,dim[1]-mki]);
                        circle(d=mki);
                    }
                }
            }
        }
        if(plane=="yz")
        {
            translate([0,mki/2,dim[2]-mki/2])
            {
                rotate([0,90,0])
                {
                    linear_extrude(dim[0])
                    {
                        minkowski()
                        {
                            square([dim[2]-mki,dim[1]-mki]);
                            circle(d=mki);
                        }
                    }
                }
            }
        }
        if(plane=="xz")
        {
            translate([mki/2,dim[1],mki/2])
            {
                rotate([90,0,0])
                {
                    linear_extrude(dim[1])
                    {
                        minkowski()
                        {
                            square([dim[0]-mki,dim[2]-mki]);
                            circle(d=mki);
                        }
                    }
                }
            }
        }
    }
}
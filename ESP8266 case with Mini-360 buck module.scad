//This is a model of the ESP8266 D1 mini 
//It can be used for case design.

/* [Size Adjustments] */
//This comment will describe the variable below it in the customizer
customizer_variable=0; //mm

//Material used (to adjust for shrinkage)
Material="PLA";//[PLA, ABS, TPU, PETG]

/* [Hidden] */

// General sizes
wallThickness=1.5;
wireChannelWidth=5.6;
wireChannelDepth=2.6;
wireChannelLength=10;
strainReliefLength=4;
strainReliefThickness=2;
mountingScrewDiameter=3.5;
mount=wallThickness*2+mountingScrewDiameter;

//space for ESP8266
espThickness=2.3;
espLength=35+wireChannelWidth/4; //room for one power wire to 3v3
espWidth=26.5;
wireChannelGroundX=wallThickness+espLength-11.4;
wireChannelGroundY=wallThickness+espWidth;

//space for Mini-360 Buck Converter
mini360Length=18.5;
mini360Width=12;
mini360Thickness=5;
mini360LocationX=wallThickness;
mini360LocationY=espWidth+wallThickness*2;

//case
caseWidth=espWidth+mini360Width+wallThickness*3;
caseLength=espLength+wallThickness*2;
lowerCaseThickness=6; 
caseTopThickness=3; 

//LED
ledLength=0.8;
ledWidth=1.4;
ledThickness=0.5;
ledLocationX=6;   //from edge of wifi board
ledLocationY=13.8;//from edge of wifi board

//reset button
resetNotchLength=7.5;
resetNotchWidth=2.1;
resetNotchLocationX=27;
resetButtonBodyLength=4.5;
resetButtonBodyWidth=2.1;
resetButtonBodyThickness=2;
resetButtonBodyLocationY=resetNotchWidth;
resetButtonLength=1.8;
resetButtonWidth=1.4;
resetButtonThickness=0.85;
resetButtonLocationY=resetButtonBodyLocationY-resetButtonWidth;
resetButtonRodDiameter=2.8;
resetButtonRodLength=wallThickness+3;
resetButtonRodLocationX=34.3;
resetButtonRodLocationY=resetButtonRodLength;
resetButtonRodLocationZ=lowerCaseThickness-espThickness;
resetExtensionDiameter=resetButtonRodDiameter-0.3;
resetExtensionLength=wallThickness*2.5;

//USB port
usbWidth=7.8;
usbLocationX=28;
usbLocationY=8.5;
usbOpeningLength=12;
usbOpeningWidth=wallThickness*2;
usbOpeningThickness=lowerCaseThickness;
usbOpeningLocationX=espLength+.4;
usbOpeningLocationY=usbLocationY;


shrink=[
  ["ABS",0.7],
  ["PLA",0.2],
  ["TPU",0.2],
  ["PETG",0.4]
  ];
temp=search([Material],shrink);
shrinkPCT=shrink[temp[0]][1];
fudge=.02;  //mm, used to keep removal areas non-congruent
shrinkFactor=1+shrinkPCT/100;
$fn=200;
nozzleDiameter=.4;
x=0;
y=1;
z=2;

module go()
  {
  difference()
    {
    solids();
    holes();
    }
  extra();
  }

module solids()
  {
  // the case bottom half
  cube([caseLength,caseWidth,lowerCaseThickness]);

  //the strain relief
  translate([mini360LocationX+mini360Length+wireChannelLength,
            caseWidth,
            lowerCaseThickness-wireChannelDepth-strainReliefThickness])
    {
    cube([wireChannelWidth,strainReliefLength,strainReliefThickness]);    
    }

  //mounting holes
  translate([0-mountingScrewDiameter/2,0-mountingScrewDiameter/2,0])
    cornerMount(0);
  translate([caseLength+mountingScrewDiameter/2,0-mountingScrewDiameter/2,0])
    cornerMount(90);
  translate([0-mountingScrewDiameter/2,caseWidth+mountingScrewDiameter/2,0])
    cornerMount(270);
  translate([caseLength+mountingScrewDiameter/2,caseWidth-mount/2,0])
    {
    cornerMount(180); //wire channel will overwrite one fillet
    translate([-mountingScrewDiameter/2,mountingScrewDiameter/2,0]) //go ahead and fill in the missing fillet area
    cube([wallThickness,wallThickness,lowerCaseThickness]);
    }
  }

module holes()
  {
  //the ESP8266 
  translate([wallThickness,wallThickness,lowerCaseThickness-espThickness])
    {
    cube([espLength,espWidth,espThickness+fudge]);
    }
  translate([wallThickness+wireChannelWidth/4,wallThickness,wallThickness])
    {
    import("ESP8266-D1-mini.stl");
    }

  //Opening for USB plug
  translate([usbOpeningLocationX+fudge,usbOpeningLocationY,0-fudge/2])
    {
    cube([usbOpeningWidth,usbOpeningLength,usbOpeningThickness+fudge]);
    }

  
  //the Mini-360
  translate([mini360LocationX,mini360LocationY,lowerCaseThickness-mini360Thickness+fudge])
    {
    cube([mini360Length,mini360Width,mini360Thickness]);
    }

  //12v power wire channel
  translate([mini360LocationX+mini360Length-fudge/2,
            mini360LocationY+mini360Width/2-wireChannelWidth/2,
            lowerCaseThickness-wireChannelDepth/2+fudge])
    {
    cube([wireChannelLength+fudge,wireChannelWidth,wireChannelDepth/2]);
    }

  //Main wire channel
  translate([mini360LocationX+mini360Length+wireChannelLength,
            espWidth+wallThickness-fudge/2,
            lowerCaseThickness-wireChannelDepth+fudge])
    {
    cube([wireChannelWidth,wireChannelLength*2,wireChannelDepth]);
    }
    
  //small wire channel for 3.3v power  
  translate([wallThickness,
            espWidth+wallThickness-fudge,
            lowerCaseThickness-wireChannelDepth/2+fudge]) 
    {
    cube([wireChannelWidth/4,wireChannelLength,wireChannelDepth/2]);
    }
    
  //small wire channel for ground wire  
  translate([wireChannelGroundX-0.5,wireChannelGroundY-fudge,lowerCaseThickness-wireChannelDepth/2]) //0.5 for the board tolerance
    {
    cube([wireChannelWidth/4,wireChannelLength,wireChannelDepth/2+fudge]);
    }
  
  //the nub on the end of the strain relief
  translate([mini360LocationX+mini360Length+wireChannelLength,
            caseWidth,
            lowerCaseThickness-wireChannelDepth-strainReliefThickness])
    {
    cube([wireChannelWidth,strainReliefLength-1,strainReliefThickness/2]);    
    }

  // screw holes
  translate([0-mountingScrewDiameter/2,0-mountingScrewDiameter/2,0-fudge/2])
    cylinder(d=mountingScrewDiameter, h=lowerCaseThickness+fudge);
  translate([caseLength+mountingScrewDiameter/2,0-mountingScrewDiameter/2,0-fudge/2])
    cylinder(d=mountingScrewDiameter, h=lowerCaseThickness+fudge);
  translate([0-mountingScrewDiameter/2,caseWidth+mountingScrewDiameter/2,0-fudge/2])
    cylinder(d=mountingScrewDiameter, h=lowerCaseThickness+fudge);
  translate([caseLength+mountingScrewDiameter/2,caseWidth-mount/2,0-fudge/2])
    cylinder(d=mountingScrewDiameter, h=lowerCaseThickness+fudge);

  //reset button
  translate([resetButtonRodLocationX,resetButtonRodLocationY-fudge,resetButtonRodLocationZ])
    {
    rotate([90,0,0])
      {
      cylinder(d=resetButtonRodDiameter,h=resetButtonRodLength);
      cylinder(d=resetButtonRodDiameter*1.6,h=resetButtonRodLength-1.5);
      }
    }
    
  }

module extra()
  {
  //The reset button extension
  translate([resetButtonRodLocationX,0-5,0])
    {
    cylinder(d=resetExtensionDiameter*1.4,h=0.6);
    cylinder(d=resetExtensionDiameter,h=resetExtensionLength);
    }  
  }

module cornerMount(angle)
  {
  rotate([0,0,angle])
    {
    cylinder(d=mount, h=lowerCaseThickness);
    translate([mountingScrewDiameter/2,0,0])
      {
      difference()
        {
        cube([wallThickness+mountingScrewDiameter/2,wallThickness+mountingScrewDiameter/2,lowerCaseThickness]);
        translate([wallThickness+mountingScrewDiameter/2,0,0-fudge/2])
          {
          cylinder(d=wallThickness+mountingScrewDiameter/2+.25, h=lowerCaseThickness+fudge); //not sure where that 0.25mm came from
          }
        }
      }

    translate([0,mountingScrewDiameter/2,0])
      {
      difference()
        {
        cube([wallThickness+mountingScrewDiameter/2,wallThickness+mountingScrewDiameter/2,lowerCaseThickness]);
        translate([0,wallThickness+mountingScrewDiameter/2,0-fudge/2])
          {
          cylinder(d=wallThickness+mountingScrewDiameter/2+.25, h=lowerCaseThickness+fudge);
          }
        }
      }

    }
  }
    
go();

echo(caseLength);
echo(caseWidth);

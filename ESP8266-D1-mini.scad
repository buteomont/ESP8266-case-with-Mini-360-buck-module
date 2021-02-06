//This is a model of the ESP8266 D1 mini 
//It can be used for case design.

/* [Size Adjustments] */
//This comment will describe the variable below it in the customizer
customizer_variable=0; //mm

//Material used (to adjust for shrinkage)
Material="PLA";//[PLA, ABS, TPU, PETG]

/* [Hidden] */
//board
boardWidth=26;
boardLength=34.5;
boardThickness=1.5; //PC board only

//WiFi board
wifiLength=24;
wifiWidth=16;
wifiThickness=1;
wifiLocationX=0; //antenna to the left
wifiLocationY=5;

//RF Can
canLength=15;
canWidth=12;
canThickness=2.4;
canLocationX=7.7; //on the wifi board, from the antenna side
canLocationY=2;   //on the wifi board

//LED
ledLength=0.8;
ledWidth=1.4;
ledThickness=0.5;
ledLocationX=6;   //from edge of wifi board
ledLocationY=13.8;//from edge of wifi board

//reset switch
resetNotchLength=7.5;
resetNotchWidth=2.1;
resetNotchLocationX=27;
resetButtonBodyLength=4.8;
resetButtonBodyWidth=3;
resetButtonBodyThickness=2.3;
resetButtonBodyLocationX=30.2-resetButtonBodyWidth/2;
resetButtonBodyLocationY=resetNotchWidth;
resetButtonLength=2.5;
resetButtonWidth=1.8;
resetButtonThickness=1.2;
resetButtonLocationX=resetButtonBodyLength/2-resetButtonLength/2; //relative to resetButtonBodyLocationX
resetButtonLocationY=resetButtonBodyLocationY-resetButtonWidth;

//USB port
usbLength=6;
usbWidth=9;
usbThickness=2.8;
usbLocationX=28;
usbLocationY=boardWidth/2-usbWidth/2; //centered in Y direction

//chip
chipLength=10.5;
chipWidth=5.5;
chipThickness=1.8;
chipLocationX=19;
chipLocationY=6.4;

//room for solder connections
pinsWidth=2.5;
pinsLength=21;
pinsThickness=2;
pinsLocationX=6;
pinsLocationY1=0;
pinsLocationY2=23;

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
  //main circuit board
  cube([boardLength, boardWidth, boardThickness]);

  //wifi board
  translate([wifiLocationX,wifiLocationY,boardThickness])
    {
    cube([wifiLength,wifiWidth,wifiThickness]);

    //RF can
    translate([canLocationX,canLocationY,wifiThickness])
      {
      cube([canLength,canWidth,canThickness]);
      }

    //LED
    translate([ledLocationX,ledLocationY,wifiThickness])
      {
      cube([ledLength,ledWidth,ledThickness]);
      }
    }

  // USB port
  translate([usbLocationX,usbLocationY,-usbThickness])
    {
    cube([usbLength,usbWidth,usbThickness]);
    }

  //chip
  translate([chipLocationX,chipLocationY,0-chipThickness])
    {
    cube([chipWidth,chipLength,chipThickness]);
    }

  //pins (for solder space)
  translate([pinsLocationX,pinsLocationY1,0-pinsThickness])
    {
    cube([pinsLength,pinsWidth,pinsThickness]);
    translate([0,pinsLocationY2,0])
      {
      cube([pinsLength,pinsWidth,pinsThickness]);
      }
    }
  }

module holes()
  {
  //Reset button notch
  translate([resetNotchLocationX,0-fudge/2,0-fudge/2])
    {
    cube([resetNotchLength+fudge,resetNotchWidth+fudge,boardThickness+fudge]);
    }
  }

module extra()
  {
  //Reset button
  translate([resetButtonBodyLocationX,resetButtonBodyLocationY,-resetButtonBodyThickness])
    {
    cube([resetButtonBodyLength,resetButtonBodyWidth,resetButtonBodyThickness]);
    translate([resetButtonLocationX,-resetButtonWidth,resetButtonBodyThickness/2-resetButtonThickness/2])
      {
      cube([resetButtonLength,resetButtonWidth,resetButtonThickness]);
      }
    }

  }
  
translate([0,0,usbThickness]) //USB port sticks down the most
  go();

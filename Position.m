% Position
% Detecting the intial starting position is very important to me :/

theta = 0;
phi = 0;
psii = 0;

%x axis rotation to/fro 
x = [1 0 0 ; 0 cos(phi) -sin(phi) ; 0 sin(phi) cos(phi)];

%y axis rotation left/right
y = [cos(theta) 0 sin(theta) ; 0 1 0 ; -sin(theta) 0  cos(theta)];

%z axis rotation up/down
z = [cos(psii) -sin(psii) 0 ; sin(psii) cos(psii) 0 ; 0 0 1 ]

%Transitions 

do
	%Sitting
	if {
		theta = 0;
		phi = 0;
		psii = 0;
	}
	

	%Standing

		theta = 0;
		phi = pi/2;
		psii = 0;

	%Supine

	x3;

	%Lying

	x4;

	%Prone

	x5;

	%Left Lateral 

	x6;

	%Right Lateral

	x7;

	%Knelling 

	x8;

	%Crouching

	x9;

	%Bending

	x10;

while(theta ~= 0 && psii ~= 0 && phi ~= 0)

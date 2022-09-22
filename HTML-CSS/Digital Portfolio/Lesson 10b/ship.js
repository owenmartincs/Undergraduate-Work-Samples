//declaring a function called Ship
//_x and _y are placeholder variables
//those values will be determined in the animation file, and then every _x and _y will be replaced with that number



function Ship(_x, _y)
{

//it has the following properties


this.x = _x;
this.y = _y;

//ax and ay are accelaration
this.ax = 1;
this.ay = 1;
this.vx = 0;
this.vy = 0;
this.radians = 0;
this.degrees = 0;
this.power = 1;

//it has the following methods 
//it can move

this.move = function()
{


}

//and it can draw

this.draw = function ()
{
	//saves the current status of the context, so we can use the starting point later

	context.save();

	//takes the point of origin and moves it to the x and y
	
	//this code must be removed in order for the collision function to work

	//context.translate(this.x, this.y);

	//draw black line

	context.strokeStyle = "#000000";

	//begin drawing

	context.beginPath();

		//move draw point to x and y coordinates +/- pixels to move into the shape of a ship

		context.moveTo(this.x + 10, this.y);

		context.lineTo(this.x - 10, this.y - 7);

		context.lineTo(this.x - 3, this.y);

		context.lineTo(this.x - 10, this.y + 7);
	
		context.lineTo(this.x + 10, this.y);


	context.closePath();
	context.stroke();

	// brings it back to what the stroke style and translate occurred.
	
	//this code must be removed in order for the collision function to work

	//context.restore();

	

}


}
function Ship(_x, _y)
{
this.x = _x;
this.y = _y;
this.ax = 3;
this.ay = 1;
this.vx = 0;
this.vy = 0;
this.radians = 0;
this.degrees = 0;
this.power = 1;

this.draw = function ()
{
	context.save();
	var img = new Image();
	img.src = 'snowmanEmoji.png';
	context.drawImage(img,this.x,this.y,150,150);
}

}
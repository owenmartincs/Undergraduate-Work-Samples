function Particle(_x, _y, _vx, _vy, _radius)
{
	this.x = _x;
	this.y = _y;
	this.radius = _radius;
	this.vy = _vy;
	this.vx = _vx;
	this.color = "rgb("+
				  Math.round(Math.random() * 255)+
				  ","+
				   Math.round(Math.random() * 255)+
				  ","+
				   255+
				  ")";
	this.startY = this.y;
	this.startX = this.x;
	this.distance = 0;

	this.draw = function()
	{
		context.beginPath();
		context.fillStyle= this.color;  
		context.arc(this.x, this.y, this.radius, 0 * Math.PI/180, 360 * Math.PI/180, true);
		context.fill();
		context.closePath();
	}
	
	this.move = function()
	{
		this.y+= this.vy;
		this.x+= this.vx;
		this.reset();
	}

	this.reset = function ()
	{
		if (this.y >= canvas.height)
		{
			this.y = this.startY;
			this.x = Math.round(Math.random() * canvas.width);
			this.radius = Math.random() * 10 + 5;
			this.vy = -Math.random() * 15 + 15;
		}
}
	this.collision = function(_obj)
		{
			var dx = _obj.x - this.x;
			var dy = _obj.y - this.y;
			this.distance = Math.sqrt (dx * dx + dy * dy);
			if(this.distance < this.radius)
				{
					return true;
				}
			return false;
		}
}
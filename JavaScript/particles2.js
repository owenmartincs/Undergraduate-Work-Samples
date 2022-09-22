function Particle(_x, _y, _vx, _vy, _radius)
{
	this.x = _x;
	this.y = _y;
	this.radius = _radius;
	this.vy = _vy;
	this.vx = _vx;
	this.startY = this.y;
	this.startX = this.x;
	this.distance = 0;

	this.draw = function()
	{
		var img = new Image();
		img.src = 'snowflakeEmoji.png';
		context.drawImage(img,this.x,this.y,47,53);
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
			this.radius = 64;
			this.vy = -Math.random() * 10 + 20;
		}
}
this.collision = function(_obj)
		{
			var dx = (_obj.x + 50) - this.x;
			var dy = _obj.y - this.y;
			this.distance = Math.sqrt (dx * dx + dy * dy);
			if(this.distance < this.radius)
				{
					return true;
				}
			return false;
		}
}
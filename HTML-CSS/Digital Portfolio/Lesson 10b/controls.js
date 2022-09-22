var up = false;
var down = false;
var left = false;
var right = false;

window.onkeydown = function(e){
	
	if(e.keyCode == 38)
		{
		up = true;	
		}
	
	if(e.keyCode == 40)
		{
		down = true;	
		}
	
	if(e.keyCode == 37)
		{
		left = true;	
		}
	
	if(e.keyCode == 39)
		{
		right = true;	
		}
	
}

window.onkeyup = function(e){
	
	if(e.keyCode == 38)
		{
		up = false;	
		}
	
	if(e.keyCode == 40)
		{
		down = false;	
		}
	
	if(e.keyCode == 37)
		{
		left = false;	
		}
	
	if(e.keyCode == 39)
		{
		right = false;	
		}
	
}

var canvas;
var context;
var ship = new Ship(350, 100);
var friction = .85;  
ship.power = 2;
var count = 0;
gravity = .2;
var asteroids = new Array();
var amount = 10;


window.onload = function()
{
	canvas = document.getElementById("etchasketch");
	context = canvas.getContext("2d");
	for(var i = 0; i < amount; i++)
	{
		var x = Math.random() * canvas.width;
		var y = Math.random() * canvas.height - canvas.height;
		var vx = 0;
		var vy = -Math.random() * 10 + 20;
		var radius = 64;	
		asteroids[i] = new Particle(x, y, vx, vy, radius);
	}
	var interval = setInterval ("animate()", 1000/30);
}

function animate ()
{
	context.clearRect(0,0,canvas.width, canvas.height);

	if(right == true)
	{
		ship.vx += ship.ax * ship.power;
	}
	if(left == true)
	{
		ship.vx += ship.ax * -ship.power;
		
	}
	/*if(up == true)
	{
		ship.vy += -ship.ay * 1.5 * ship.power;
	}
	if(down == true)
	{
		ship.vy += ship.ay * ship.power;
	}*/
	
	if (ship.x > canvas.width - 150)
	{
		ship.x = canvas.width - 150;
	}
	if (ship.x < 0)
	{
		ship.x = 0;
	}
	if (ship.y < 645)
	{
		ship. y = 645;
	}
	if (ship.y > 645)
	{
		ship.y = 645;
	}
	ship.vx *= friction;
	ship.vy *= friction;
	ship.vy += gravity;
	ship.x += ship.vx;
	ship.y += ship.vy;
	ship.draw();
	for(var i = 0; i < amount; i++)
	{
		asteroids[i].move();
		asteroids[i].draw();

		if (asteroids[i].collision(ship))
			{
				count++;
				asteroids[i].y = asteroids[i].startY;
			}
	}
	if (count >= 50)
	{
		var img = new Image();
		img.src = 'santaHatEmoji3.png';
		context.drawImage(img,ship.x + 35,ship.y - 7,83,86);
		context.fillText ("Santa Hat Collected!", 10, 40);
	}
	if (count >= 100)
	{
		var img2 = new Image();
		img2.src = 'presentEmoji.png';
		context.drawImage(img2,ship.x - 25, ship.y + 45,60,60);
		context.fillText ("Present Collected!", 10, 60);
	}
	if (count >= 150)
	{
		var img3 = new Image();
		img3.src = 'bellEmoji.png';
		context.drawImage(img3,ship.x + 120, ship.y + 50,60,60);
		context.fillText ("Bell Collected!", 10, 80);
	}
	
	context.fillStyle = "#00ffff";
	context.font = "20px Georgia";
	context.fillText ("Snowflakes Collected:", 10, 20);
	context.fillText(count, 210, 20);
}


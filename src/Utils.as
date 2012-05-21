package  
{
	import GameObject.PlayableObject;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Tom
	 */
	public class Utils 
	{
		public static function normalize(p:FlxPoint) : FlxPoint {
			var dist:Number = Math.sqrt(p.x * p.x + p.y * p.y);
			return new FlxPoint(p.x / dist, p.y / dist);
		}
		
		public static function direction(p1:FlxPoint, p2:FlxPoint) : FlxPoint {
			var dir:FlxPoint = new FlxPoint(p2.x - p1.x, p2.y - p1.y);
			return normalize(dir);
		}
		
		public static function distance(p1:FlxPoint, p2:FlxPoint) : Number {
			var dir:FlxPoint = new FlxPoint(p2.x - p1.x, p2.y - p1.y);
			return (Math.sqrt(dir.x*dir.x + dir.y*dir.y));
		}
		
		public static function add1v(v:FlxPoint, x:Number) : FlxPoint {
			return new FlxPoint(v.x + x, v.y + x);
		}
		
		public static function add2v(v1:FlxPoint, v2:FlxPoint) : FlxPoint {
			return new FlxPoint(v1.x + v2.x, v1.y + v2.y);
		}
		
		public static function mult1v(v:FlxPoint, x:Number) : FlxPoint {
			return new FlxPoint(v.x * x, v.y * x);
		}
		
		public static function mult2v(v1:FlxPoint, v2:FlxPoint) : FlxPoint {
			return new FlxPoint(v1.x * v2.x, v1.y * v2.y);
		}
		
		public static function dotProduct(v1:FlxPoint, v2:FlxPoint) : Number {
			return (v1.x * v2.x + v1.y * v2.y);
		}
		
		public static function random(low:Number, high:Number):Number {
			return Math.random() * (high - low) + low;
		}
		
		public static function getArrayofNumbers(init:int, n:int ):Array {
			var tab:Array = new Array();
			var i:int
			if (init < n)
			{
				for (i = init; i <= n ; i++) 
				{
					tab.push(i);
				}
			}
			else 
			{
				for (i = init; i >= n ; i--) 
				{
					tab.push(i);
				}
			}
			
			return tab;
		}
		
		public static function getDirectionID(dir:FlxPoint):int {
			if (dir.x > 0) {
				//top
				if (dir.y < 0) { return 1; }
				//bottom
				if (dir.y > 0) { return 3; }
				//straight
				else { return 2; }
			//left
			}else if (dir.x < 0){
				//top
				if (dir.y < 0) { return 7; }
				//bottom
				if (dir.y > 0) { return 5; }
				//straight
				else { return 6 ; }
			//nor left either right
			}else {
				//top
				if (dir.y < 0) { return 0; }
				//bottom
				else { return 4; }
			}
		}
		
		public static function getDirectionPoint(id:int):FlxPoint {
			switch(id) {
				case 0 : return new FlxPoint(0, -1); break;
				case 1 : return new FlxPoint(1, -1); break;
				case 2 : return new FlxPoint(1, 0); break;
				case 3 : return new FlxPoint(1, 1); break;
				case 4 : return new FlxPoint(0, 1); break;
				case 5 : return new FlxPoint(-1, 1); break;
				case 6 : return new FlxPoint(-1, 0); break;
				case 7 : return new FlxPoint(-1, -1); break;
			}
			return null;
		}
	}

}
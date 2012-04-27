package  
{
	import flash.geom.Rectangle;
	import org.flixel.FlxParticle;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class Hitbox 
	{
		protected var m_position:FlxPoint;
		protected var m_size:FlxPoint;
		protected var m_center:FlxPoint;
		
		public function Hitbox(x:Number,y:Number,width:Number,height:Number) 
		{
			m_position = new FlxPoint(x, y);
			m_size = new FlxPoint(width, height);
			m_center = new FlxPoint(x + width / 2, y + height / 2);
		}
		
		public function getCenter():FlxPoint {
			return m_center;
		}
		
		public function getPosition() : FlxPoint {
			return m_position;
		}
		
		public function getWidth() : Number {
			return m_size.x;
		}
		
		public function getHeight() : Number {
			return m_size.y;
		}
		
		public function get x():Number {
			return m_position.x;
		}
		
		public function get y():Number {
			return m_position.y;
		}
		
		public function get width():Number {
			return m_size.x;
		}
		
		public function get height():Number {
			return m_size.y;
		}
	}

}
package GameObject 
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Tom
	 */
	public class MovableObject extends DrawableObject 
	{
		public var m_speed:Number = 1;
		public var m_direction:FlxPoint;
		public var m_directionFacing:FlxPoint;
		protected var m_blocked:Boolean = false;
		public var m_oldPos:FlxPoint;
		
		public function MovableObject(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_direction = new FlxPoint(0, 0);
			m_directionFacing = new FlxPoint(1,0);
			m_oldPos = new  FlxPoint(x,y);
		}
		
		public function move() : void {
			m_oldPos.x = x; m_oldPos.y = y;
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
		}
		
		public function stop():void {
			m_direction.x = 0; m_direction.y = 0;
		}
		public function goTo(object:GameObject):void {
			m_direction = Utils.normalize(new FlxPoint((object.getCenter().x - this.x), (object.getCenter().y - this.y)));;
		}
		
		public function goToPoint(point:FlxPoint):void {
			m_direction = Utils.normalize(new FlxPoint((point.x - this.x), (point.y - this.y)));;
		}
		
		public function block():void {
			m_blocked = true;
		}
		
		public function unblock():void {
			m_blocked = false;
		}
	}

}
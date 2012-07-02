package GameObject.Other 
{
	import GameObject.MovableObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class Butterfly extends MovableObject
	{
		protected var m_timerMove:FlxTimer;
		protected var TIME_MOVE:Number = 4;
		
		public function Butterfly(X:Number,Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Others/butterfly.png";
			m_width = 16; m_height = 16;
			m_bufferGroup = DepthBufferPlaystate.s_nppGroup;
			m_timerMove = new FlxTimer();
			setColor();
			m_speed = 0.1;
		}
		
		override public function load():void {
			super.load();
			addAnimation("fly_left", [0, 1, 2], 5, true);
			addAnimation("fly_right", [3, 4, 5], 5, true);
			act();
			
		}
		
		override public function update():void {
			if (Global.frozen)
				return;
			move();
			if (m_timerMove.finished) {
				act();
			}
		}
		
		/**
		 * Randomly chose a new direction
		 */
		override public function act():void {
			var dir:FlxPoint = new FlxPoint(Utils.random( -1, 1), Utils.random( -1, 1));
			m_direction = Utils.normalize(dir);
			if (m_direction.x > 0)
				play("fly_right");
			else
				play("fly_left");
			m_timerMove.start( TIME_MOVE * Utils.random(1, 2.3));
		}
		
		/**
		 * Randomly set a color to the sprite
		 */
		private function setColor():void {
			var r:int = Utils.random(0, 100);
			if (r < 25)
				color = 0x00FFFF;
			else if (r < 50)
				color = 0xFF0000;
			else if (r < 75)
				color = 0xFFFF00;
			else
				color = 0x8000FF;
		}
		
	}

}
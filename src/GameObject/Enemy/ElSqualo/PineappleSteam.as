package GameObject.Enemy.ElSqualo 
{
	import GameObject.DrawableObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PineappleSteam extends DrawableObject 
	{
		private var m_timer:FlxTimer;
		
		public function PineappleSteam() 
		{
			super();
			m_url = "Images/Enemies/ElSqualo/pineapple.png";
			m_width = 32; m_height = 32;
			m_bufferGroup = DepthBufferPlaystate.s_foregroundGroup;
			m_timer = new FlxTimer();
		}
		
		override public function load():void {
			super.load();
			frame = 4;
		}
		
		public function shoot(X:int, Y:int ):void {
			x = X; y = Y;
			alpha = 1;
			scale.x = 1; scale.y = 1;
			m_timer.start(1);
			addToStage();
		}
		
		override public function update():void {
			y -= 0.1;
			alpha = 1 - m_timer.progress;
			scale = new FlxPoint(1 - m_timer.progress*0.5 , 1 - m_timer.progress*0.5);
			if (m_timer.finished) {
				removeFromStage();
			}
		}
	}

}
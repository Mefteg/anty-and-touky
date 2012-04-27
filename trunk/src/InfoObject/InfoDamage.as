package InfoObject 
{
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class InfoDamage extends Info
	{
		private var m_timer:FlxTimer;
		
		private var m_up:Number;
		
		public function InfoDamage(X:Number = 0, Y:Number = 0,text:String= null,colour:uint = 0xFFFFFF,Width:uint = 40 ) 
		{
			super(X, Y , text,Width);
			m_timer = new FlxTimer();
			m_timer.start(1.5);
			m_up = 4;
			x += Utils.random( -3, 3);
			this.color = colour;
		}
		
		override public function update():void {
			if (m_timer.finished)
				removeFromStage();
				
			this.y -= m_up;
			
			m_up -= 0.2;
			if (m_up < 0)
				m_up = 0;
		}
		
	}

}
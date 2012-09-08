package GameObject.Menu 
{
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author Tom
	 */
	public class MyTempButton extends MyButton 
	{
		public var m_duration:Number;
		public	var	m_timer:FlxTimer;
		
		public function MyTempButton(infos:Array) 
		{
			super(infos);
			m_duration = infos["duration"];
			m_timer = new FlxTimer();
			m_timer.start(m_duration);
		}
		
		override public function update() : void {
			super.update();
		}
		
		public function isActive() : Boolean
		{
			return !m_timer.finished;
		}
	}

}
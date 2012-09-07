package Scene 
{
	import flash.display.SWFVersion;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class Transition extends FlxBasic
	{
		private var m_swfLoader:SWFLoader;
		private var m_sound:FlxSound;
		private var m_timer:FlxTimer;
		private var TIME:Number;
		private var m_state:String;
		private var m_url:String;
		
		public function Transition(url:String, time:Number, boss:Boolean = true ) 
		{
			super();
			m_sound = new FlxSound();
			if (boss)
				m_sound.loadStream("Music/NewEncounter.mp3");
			else
				m_sound.loadStream("Music/NewArea.mp3");
			m_swfLoader = new Scene.SWFLoader();
			m_timer = new FlxTimer();
			TIME =  time;
			m_state = "waiting";
			m_url = url;
		}
		
		public function play():void {
			Global.currentPlaystate.m_transitionComplete = false;
			m_swfLoader.load(m_url);
			Global.currentPlaystate.pauseMusic();
			Global.currentPlaystate.add(this);
			m_state = "loading";
		}
		
		override public function update():void {
			if (m_state == "loading") {
				if (m_swfLoader.isComplete()) {
					m_sound.play();
					m_timer.start(TIME);
					m_state = "playing";
				}
			}
			if (m_timer.finished && m_state != "over" ) {
				m_state = "over";
				Global.currentPlaystate.m_transitionComplete = true;
				Global.currentPlaystate.resumeMusic();
				m_swfLoader.stopSWF();
				Global.currentPlaystate.remove(this);
			}
		}
		
		public function isOver():Boolean {
			return m_state == "over";
		}
		
	}

}
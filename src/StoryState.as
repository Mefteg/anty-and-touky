package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	import Scene.Library;
	/**
	 * ...
	 * @author ...
	 */
	public class StoryState extends State 
	{
		
		[Embed(source = "../bin/Images/Menu/intro.swf")] protected var Intro:Class;
		
		private var m_timerSwitch:FlxTimer;
		//images to display
		private var m_timerMessage:FlxTimer;
		
		private var m_intro:MovieClip;
		
		public function StoryState() 
		{
			depthBuffer = new DepthBuffer();
			add(depthBuffer);
			m_state = "Loading";
			m_library = Global.library;
			m_timerSwitch = new FlxTimer();
			m_intro = new Intro();
			FlxG.stage.addChild(m_intro);
			m_intro.play();
		}
		
		override public function create():void {
			super.create();
			m_timerSwitch.start(30);
		}
		
		override public function update():void {
			doStateUpdate();
			switch(m_state) {
				//load images
				case "Loading": if (m_timerSwitch.finished) end(); break;
				case "Ending":ending(); break;
				default : break;
			}
			
			if ( FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("ESCAPE") ) {
				this.end();
			}
		}
		
				
			
		override public function end():void {
			m_state = "Ending";
			FlxG.stage.removeChild(m_intro);
			fadeOut(4);
		}
		
		override protected function ending():void {
			if (m_fadeOut)
				return;
			FlxG.switchState( new Playstate() );
		}
		
		private function doStateUpdate():void {
			var basic:FlxBasic;
			var i:uint = 0;
			while(i < length)
			{
				basic = members[i++] as FlxBasic;
				if((basic != null) && basic.exists && basic.active)
				{
					basic.preUpdate();
					basic.update();
					basic.postUpdate();
				}
			}
			//for fades
			if (m_fadeIn)
				processFadeIn()
			else if (m_fadeOut)
				processFadeOut();
			
		}
	}

}
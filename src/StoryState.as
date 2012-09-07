package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import GameObject.DrawableObject;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	import Scene.Library;
	import Scene.SWFLoader;
	import Scene.Transition;
	/**
	 * ...
	 * @author ...
	 */
	public class StoryState extends State 
	{		
		private var m_timerSwitch:FlxTimer;
		//images to display
		private var m_timerMessage:FlxTimer;
		
		private var m_intro:MovieClip;
		private var m_swfLoader:SWFLoader;
		
		private var m_loadEgg:DrawableObject;
		
		public function StoryState() 
		{
			depthBuffer = new DepthBuffer();
			add(depthBuffer);
			m_state = "Loading";
			m_library = Global.library;
			m_timerSwitch = new FlxTimer();
			m_swfLoader = new SWFLoader();
			m_swfLoader.load("Images/Menu/intro.swf");
			m_sound = new FlxSound();
			m_sound.loadStream("Music/Intro.mp3", false);
			//loading Egg
			m_loadEgg = new DrawableObject(FlxG.width - 40, FlxG.height - 40);
			m_loadEgg.m_url = "Images/Weapons/egg.png";
			m_loadEgg.m_height = 32; m_loadEgg.m_width = 32;
			m_loadEgg.load();
			m_loadEgg.addAnimation("rot", [0, 1, 2, 3, 4, 5, 6, 7], 10, true);
			m_loadEgg.play("rot");
			add(m_loadEgg);
			m_loadProgression = new FlxText(0, FlxG.height-10, 500);
			add(m_loadProgression);
		}
		
		override public function create():void {
			super.create();
		}
		
		override public function update():void {
			doStateUpdate();
			m_loadProgression.text = "Loading : "+m_swfLoader.progress()+ "%";
			switch(m_state) {
				//load images
				case "Loading": if (m_swfLoader.isComplete()) {
									m_sound.play();
									m_state = "Playing";
									remove(m_loadProgression);
									remove(m_loadEgg);
									m_timerSwitch.start(27);
								}
				case "Playing": if (m_timerSwitch.finished) end(); break;
				case "Ending":ending(); break;
				default : break;
			}
			
			if ( FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("ESCAPE") ) {
				this.end();
			}
		}
		
				
			
		override public function end():void {
			m_state = "Ending";
			m_swfLoader.stopSWF();
			m_sound.stop();
			//fadeOut(4);
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
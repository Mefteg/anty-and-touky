package  
{
	import flash.display.MovieClip;
	import GameObject.DrawableObject;
	import GameObject.Menu.MenuBegin;
	import GameObject.Menu.MVCButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTileblock;
	import org.flixel.FlxTimer;
	import Scene.Library;
	import Scene.SceneManager;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Genericstate extends State 
	{
		[Embed(source = "../bin/Images/Menu/LadyBugRidersScreen.png")] protected var LadyBugScreen:Class;
		[Embed(source = "../bin/Images/Menu/cursor.png")] protected var Cursor:Class;
		
		protected var m_timer:FlxTimer;
		protected var m_music:FlxSound;
		
		//trailer de merde
		protected var m_trailer:MovieClip;
		
		private var m_ladyBug:FlxSprite;
		
		private var m_stateLB:String = "idle";
		private var m_timerLB:FlxTimer = new FlxTimer();
		
		private var m_menuAppeared:Boolean = false;
		private var m_ending:Boolean = false;
		
		protected var m_mvcBackground:MVCButton;
		protected var m_mvcButton:MVCButton;
		
		protected var m_passwordManager:PasswordManager;
		
		protected var m_wholeTimer:FlxTimer;

		public function Genericstate()
		{
			m_state = "Loading";
			m_library = new Library();
			Global.library = m_library;
			m_uniquesLoaded = false;
			depthBuffer = new DepthBuffer();
			add(depthBuffer);
			Global.currentState = this;
			//text displaying loading advancement
			m_loadProgression = new FlxText(400, 400, 600,"");
			//add(m_loadProgression);
			m_ladyBug = new FlxSprite(410 , 320);//for CASUAL GAME CUP
			//m_ladyBug = new FlxSprite(200 , 150);
			m_ladyBug.loadGraphic(LadyBugScreen, false, false, 300, 200, true);
			Global.library.addBitmap("Images/Menu/anty_dust.jpg");
			Global.library.addBitmap("Images/Menu/touky_beer.jpg");
			Global.library.addBitmap("Images/Menu/elsqualo_toilets.jpg");
			m_sound = new FlxSound();
			m_sound.loadStream("Music/Credits.mp3");
			m_wholeTimer = new FlxTimer();
		}
		
		override public function create() : void {
			super.create();
			m_timer = new FlxTimer();
			m_timer.start(1);
			//LADYBUG
			depthBuffer.addElement(m_ladyBug, DepthBuffer.s_cursorGroup);
			m_ladyBug.alpha = 0;
			m_timerLB.start(1);
			
			m_mvcButton = new MVCButton("Menu/genericstate.xml");
		}
		
		override public function update() : void {
			super.update();
			if (m_wholeTimer.finished) {
				m_sound.stop();
				FlxG.switchState(new Victorystate());
			}
				
			if (! m_library.loadComplete()) {
				m_library.loadAll();
			}
			//make the menu appear via fade in
			if (!m_menuAppeared && m_timer.finished) {
				depthBuffer.addElement(m_mvcBackground, DepthBuffer.s_menuGroup);
				depthBuffer.addElement(m_mvcButton, DepthBuffer.s_menuGroup);
				m_menuAppeared = true;
				m_wholeTimer.start(58);
				m_sound.play();
				fadeIn();
			}
			manageLadyBug();
			if (m_ending)
				ending();
		}
		
		override protected function loading() : void {
			//charge all the bitmaps in the library
			Global.library.loadAll();
			//when the bitmaps are loaded
			if (Global.library.loadComplete()) {
				//cache them
				Global.library.cacheObjects();
				//load future images of story state
				//StoryState.loadAllBitmaps();
				m_state = "Loaded";
			}
			
		}
		
		private function manageLadyBug():void {
			if (m_menuAppeared)
				return;
			if (FlxG.keys.ENTER && Global.library.loadComplete()) {
				m_timer.start(0.01);
				m_ladyBug.visible = false;
			}
			
			switch(m_stateLB) {
				case "done":break;
				case "idle": if (m_timerLB.finished) m_stateLB = "appearing"; break;
				case "appearing": m_ladyBug.alpha += 0.01; 
								if (m_ladyBug.alpha > 0.9) { m_ladyBug.alpha = 1; m_stateLB = "staying"; m_timerLB.start(6);} break;
				case "staying": if (m_timerLB.finished) m_stateLB = "disappearing"; break;
				case "disappearing":m_ladyBug.alpha -= 0.01; 
								if (m_ladyBug.alpha < 0.1) { m_ladyBug.alpha = 0; m_stateLB = "done";} break;
				default : break;
			}
		}
		
		override public function end():void {
			if (!m_menuAppeared)
				return;
			fadeOut(2);
			m_ending = true;
		}
		
		override protected function ending():void {
			if (m_fadeOut)
				return;
			FlxG.mouse.load(Cursor);
			FlxG.mouse.hide();
			FlxG.switchState( new StoryState() );
		}
	}

}
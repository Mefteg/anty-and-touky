package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	import Scene.Library;
	/**
	 * ...
	 * @author ...
	 */
	public class StoryState extends State 
	{
		// to switch between images
		private var m_firstImage:Boolean = false;
		private var m_timerSwitch:FlxTimer;
		//images to display
		private var m_imageA:FlxSprite;
		private var m_imageB:FlxSprite;
		private var m_currentImageName:String;
		
		private var m_currentStory:int = 0;
		private var m_timerImages:FlxTimer;
		
		public function StoryState() 
		{
			m_imageA = new FlxSprite(0, 0);
			m_imageB = new FlxSprite(0, 0);
			depthBuffer = new DepthBuffer();
			add(depthBuffer);
			depthBuffer.addElement(m_imageA, DepthBuffer.s_backgroundGroup);
			depthBuffer.addElement(m_imageB, DepthBuffer.s_cursorGroup);
			m_state = "Loading";
			m_sound = new FlxSound();
			m_sound.loadStream("Music/TwoBuddies.mp3",true);
			m_sound.play();
			m_library = new Library();
			m_timerSwitch = new FlxTimer();
			m_timerSwitch.start(0.1);
			m_timerImages = new FlxTimer();
			m_timerImages.start(0.1);
			nextImage();
		}
		
		override public function update():void {
			doStateUpdate();
			
			switch(m_state) {
				//load images
				case "Loading": loading();break;
				case "Switching":switching(); break;
				case "Ending":ending(); break;
				default : break;
			}
		}
		
		override protected function loading():void {
			m_library.loadAll();
			if (m_library.loadComplete() && !m_fadeOut) {
				m_library.cacheObjects();
				loadGraphics();
				m_state = "Switching";
				m_timerImages.start(10);
				fadeIn();
			}
		}
		
		private function loadBitmaps():void {
			m_library.addBitmap("Images/StoryScenes/Story"+m_currentStory+"_a.png");
			m_library.addBitmap("Images/StoryScenes/Story"+m_currentStory+"_b.png");
			m_state = "Loading";
		}
		
		private function loadGraphics():void {
			m_imageA.loadGraphic2(m_library.getBitmap("Images/StoryScenes/Story"+m_currentStory+"_a.png"),false,false,640,480,true);
			m_imageB.loadGraphic2(m_library.getBitmap("Images/StoryScenes/Story"+m_currentStory+"_b.png"),false,false,640,480,true);
		}
		
		private function nextImage():void {
			m_currentStory ++;
			//if the story's finishedn end
			if (m_currentStory >= 3) {
				end();
				return;
			}
			loadBitmaps();
		}
		
		private function switching():void {
			//m_library.loadAll(); // load next images to avoid lags
			if (m_timerImages.finished){
				nextImage();
				fadeOut(1);
			}
			if (m_timerSwitch.finished) {
				m_timerSwitch.start(1);
				if (m_firstImage) {
					m_imageA.visible = true;
					m_imageB.visible = false;
					m_firstImage = false;
				}else {
					m_imageA.visible = false;
					m_imageB.visible = true;
					m_firstImage = true;
				}
			}
		}
		
		override public function end():void {
			m_state = "Ending";
			fadeOut(4);
		}
		
		private function ending():void {
			if (m_fadeOut)
				return;
			m_sound.stop();
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
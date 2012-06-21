package  
{
	import GameObject.DrawableObject;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	import Scene.Library;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class State extends FlxState 
	{
		
		[Embed(source = "../bin/Images/Avatars/ladybug.png")] protected var LadyBug:Class;
		
		protected var m_library:Library;
		//used to check if the unique objects have been loaded
		protected var m_uniquesLoaded:Boolean;
		protected var m_state:String ;
		
		public var depthBuffer:DepthBuffer;
		
		public var m_camera:Camera;
		
		public var m_sound:FlxSound;
		
		protected var m_loadProgression:FlxText;
		
		protected var m_dynamicLoadingObject:DrawableObject;
		
		protected var m_screenFade:FlxSprite;
		protected var m_timerFade:FlxTimer;
		protected var m_fadeOut:Boolean = false;
		protected var m_fadeIn:Boolean = false;
		
		public function State() 
		{
			m_state = "Loading";
		}
		
		override public function create() : void {				
			//create the camera
			m_camera = new Camera(0, 0, 640, 480);
			FlxG.addCamera(m_camera);
			m_screenFade = new FlxSprite(0, 0);
			m_screenFade.makeGraphic(640, 480, FlxG.bgColor);
			m_screenFade.alpha = 1;
			m_screenFade.scrollFactor.x = 0;
			m_screenFade.scrollFactor.y = 0;
			m_timerFade = new FlxTimer();
			if (!depthBuffer)
				depthBuffer = new DepthBuffer();
			depthBuffer.addElement(m_screenFade, DepthBuffer.s_cursorGroup);
		}
		
		override public function update() : void {
			super.update();
			
			//for fades
			if (m_fadeIn)
				processFadeIn()
			else if (m_fadeOut)
				processFadeOut();
			
			switch(m_state) {
				//load images
				case "Loading":
					this.loading();
					break;
				case "LoadingNewBitmap" : 
					this.loadingNewBitmap();
					break;
				case "ChangingScene": changingScene();
										break;
				case "Ending" : ending(); break;
				default : break;
			}			
		}
		
		protected function loading() : void {
			//display loading advancement
			m_loadProgression.text = "Total : " + m_library.getAdvancement().toString();
			m_loadProgression.text += "\n" + m_library.getCurrentLoaded();
		}
		
		protected function loadingNewBitmap() : void {
			Global.library.loadAll();
			if (Global.library.loadComplete()) {
				m_dynamicLoadingObject.load();
				Global.library.cacheObjects();
				m_state = "Loaded";
			}
		}
		
		protected function changingScene():void {
			
		}
		
		protected function ending():void { };
		public function end():void {}
		
		/////FADE FUNCTIONS/////////////
		public function fadeOut(time:Number = 1):void {
			if (m_fadeOut)
				return;
			m_screenFade.alpha = 0.0;
			m_timerFade.start(time);
			m_fadeOut = true;
			m_fadeIn = false;
		}
		
		protected function processFadeOut():void {
			m_screenFade.alpha = m_timerFade.progress;
			if (m_screenFade.alpha > 0.9) {
				m_screenFade.alpha = 1.0;
				m_fadeOut = false;
			}
		}
		
		public function fadeIn(time:Number = 1):void {
			if (m_fadeIn)
				return;
			m_screenFade.alpha = 1.0;
			m_timerFade.start(time);;
			m_fadeIn = true;
			m_fadeOut = false;
		}
		
		protected function processFadeIn():void {
			m_screenFade.alpha = 1 - m_timerFade.progress;
			if(m_screenFade.alpha <0.1){
				m_fadeIn = false;
				m_screenFade.alpha = 0;
			}
		}
	}

}
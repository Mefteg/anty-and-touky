package  
{
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
		//[Embed(source = "../bin/Images/Wicken.ttf", fontFamily = "Wickenden")] private static var myFont:Class;
		
		private var m_xml:XML;
		private var m_textsToDisplay:XML;
		private var m_nbTTD:int;
		private var m_currentTextID:int;
		private var m_currentText:String;
		private var m_displayedText:String;
		private var m_index:int;
		private var m_counterLetter:int;
		private var m_writing:Boolean;
		// to switch between images
		private var m_firstImage:Boolean = false;
		private var m_timerSwitch:FlxTimer;
		//images to display
		private var m_imageA:FlxSprite;
		private var m_imageB:FlxSprite;
		private var m_currentImageName:String;
		
		private var m_text:FlxText;
		
		private var m_currentStory:int = 0;
		private var m_timerMessage:FlxTimer;
		
		public function StoryState() 
		{
			m_imageA = new FlxSprite(0, 0);
			m_imageB = new FlxSprite(0, 0);
			depthBuffer = new DepthBuffer();
			add(depthBuffer);
			depthBuffer.addElement(m_imageA, DepthBuffer.s_backgroundGroup);
			depthBuffer.addElement(m_imageB, DepthBuffer.s_backgroundGroup);
			m_text = new FlxText(70, 400, 480, "");
			m_text.setFormat(null, 18, 0xD76B00);
			depthBuffer.addElement(m_text, DepthBuffer.s_backgroundGroup);
			m_state = "Loading";
			m_sound = new FlxSound();
			m_sound.loadStream("Music/TwoBuddies.mp3",true);
			m_library = Global.library;
			m_timerSwitch = new FlxTimer();
			m_timerSwitch.start(0.1);
			m_timerMessage = new FlxTimer();
			m_timerMessage.start(0.1);
			loadXML("Scripts/story.xml");
		}
		
		override public function update():void {
			doStateUpdate();
			if (!m_library.loadComplete)
				m_library.loadAll();
			switch(m_state) {
				//load images
				case "Beginning" : if (m_xml) { nextImage(); m_state = "Switching";} break;
				case "Loading": loading(); break;
				case "Fading" : m_library.loadAll();
								if ( ! m_fadeOut && currentBitmapsLoaded() ) { 
									fadeIn(); m_state = "Switching"; 
									m_library.cacheObjects();
									loadGraphics(); 
								} break;
				case "Switching":switching(); break;
				case "Ending":ending(); break;
				default : break;
			}
			
			if ( FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("ESCAPE") ) {
				this.end();
			}
		}
		
		override protected function loading():void {
			m_library.loadAll();
			if (m_library.loadComplete()) {
				m_library.cacheObjects();
				m_currentStory = 0;
				m_sound.play();
				m_state = "Beginning";
				fadeIn();
			}
		}
		
		public static function loadAllBitmaps():void {
			Global.library.addBitmap("Images/StoryScenes/story1_a.jpg");
			Global.library.addBitmap("Images/StoryScenes/story1_b.jpg");
			Global.library.addBitmap("Images/StoryScenes/story2_a.jpg");
			Global.library.addBitmap("Images/StoryScenes/story2_b.jpg");
			Global.library.addBitmap("Images/StoryScenes/story3_a.jpg");
			Global.library.addBitmap("Images/StoryScenes/story3_b.jpg");
		}
		
		private function loadGraphics():void {
			m_imageA.loadGraphic2(m_library.getBitmap("Images/StoryScenes/story"+m_currentStory+"_a.jpg"),false,false,640,480,true);
			m_imageB.loadGraphic2(m_library.getBitmap("Images/StoryScenes/story" + m_currentStory + "_b.jpg"), false, false, 640, 480, true);
		}
		
		private function currentBitmapsLoaded():Boolean {
			return m_library.isBitmapLoaded("Images/StoryScenes/story" + m_currentStory + "_a.jpg") && 
					m_library.isBitmapLoaded("Images/StoryScenes/story" + m_currentStory + "_b.jpg");
		}
		
		private function nextImage():void {
			m_currentStory ++;
			//if the story's finishedn end
			if (m_currentStory >= 4) {
				end();
				return;
			}
			
			m_textsToDisplay = m_xml.story[m_currentStory - 1];
			m_nbTTD = m_textsToDisplay.message.length();
			m_currentTextID = 0;
			initWriting();
			m_timerMessage.start(m_nbTTD * 5);
			if(m_currentStory >1){
				fadeOut();
				m_state = "Fading";
			}else {				
				loadGraphics();
			}
		}
		
		private function nextMessage():void {
			if (m_timerMessage.finished && !m_writing) {
				m_currentTextID++; 
				//if all the messages have been displayed
				if(m_currentTextID >= m_nbTTD){
					nextImage();
					fadeOut(1);
					return;
				}
				//else
				initWriting();
			}
		}
		
		private function switching():void {
			//write the message
			write();
			//check for a new message to display
			nextMessage();
			m_library.loadAll(); // load next images to avoid lags
			if (m_timerSwitch.finished) {
				m_timerSwitch.start(1);
				if (m_firstImage) {
					m_text.y += 8;
					m_imageA.visible = true;
					m_imageB.visible = false;
					m_firstImage = false;
				}else {
					m_text.y -= 8;
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
		
		override protected function ending():void {
			if (m_fadeOut)
				return;
			m_sound.stop();
			for (var i:int = 1; i < 4 ; i++ ) {
				Global.library.deleteBitmap("Images/StoryScenes/story"+i+"_a.jpg");
				Global.library.deleteBitmap("Images/StoryScenes/story" + i + "_b.jpg");
			}
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
		
		/**************************************************************/
		//////////////////// XML LOADING///////////////////////////////
		private function loadXML(url:String):void 
		{
			var request:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(request);
		}
		
		private function onComplete(e:Event):void
		{
			m_xml = new XML(e.target.data);
		}
		/***************************************************************/
		
		private function initWriting():void {
			m_index = 0;
			m_counterLetter = 0;
			m_displayedText = "";
			m_currentText = m_textsToDisplay.message[m_currentTextID].@text.toString();
			m_writing = true;
		}
		
		private function write():void {
			m_counterLetter ++;
			if ( !m_writing || m_counterLetter< 5)
				return;
			m_displayedText += m_currentText.charAt(m_index);
			m_text.text = m_displayedText;
			m_index++;
			m_counterLetter = 0;
			if(m_index >= m_currentText.length){
				m_timerMessage.start(3.5);
				m_writing = false;
			}
		}
	}

}
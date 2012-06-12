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
			m_text = new FlxText(70, 400, 480, "EEDDEE");
			m_text.setFormat(null, 18, 0xD76B00);
			depthBuffer.addElement(m_text, DepthBuffer.s_backgroundGroup);
			m_state = "Beginning";
			m_sound = new FlxSound();
			m_sound.loadStream("Music/TwoBuddies.mp3",true);
			m_sound.play();
			m_library = new Library();
			m_timerSwitch = new FlxTimer();
			m_timerSwitch.start(0.1);
			m_timerMessage = new FlxTimer();
			m_timerMessage.start(0.1);
			loadXML("Scripts/story.xml");
		}
		
		override public function update():void {
			doStateUpdate();
			
			switch(m_state) {
				//load images
				case "Beginning" : if (m_xml) nextImage(); break;
				case "Loading": loading();break;
				case "Switching":switching(); break;
				case "Ending":ending(); break;
				default : break;
			}
			
			if ( FlxG.keys.justPressed("ENTER") ) {
				this.end();
			}
		}
		
		override protected function loading():void {
			m_library.loadAll();
			if (m_library.loadComplete() && !m_fadeOut) {
				m_library.cacheObjects();
				loadGraphics();
				m_state = "Switching";
				m_timerMessage.start(m_nbTTD * 5);
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
			if (m_currentStory >= 4) {
				end();
				return;
			}
			loadBitmaps();
			m_textsToDisplay = m_xml.story[m_currentStory - 1];
			m_nbTTD = m_textsToDisplay.message.length();
			m_currentTextID = 0;
			initWriting();
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
			//m_library.loadAll(); // load next images to avoid lags
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
			if ( !m_writing || m_counterLetter< 10)
				return;
			m_displayedText += m_currentText.charAt(m_index);
			m_text.text = m_displayedText;
			m_index++;
			m_counterLetter = 0;
			if(m_index >= m_currentText.length){
				m_timerMessage.start(5);
				m_writing = false;
			}
		}
	}

}
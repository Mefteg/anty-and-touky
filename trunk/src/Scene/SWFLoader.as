package Scene 
{
	/**
	 * ...
	 * @author ...
	 */
	public class SWFLoader 
	{
		import flash.net.URLRequest;
		import flash.display.Loader;
		import flash.events.Event;
		import flash.events.ProgressEvent;
		import org.flixel.FlxG;
		
		protected var m_complete:Boolean = false;
		protected var m_eventLoaded:Event;
		
		var m_loader:Loader;
		
		public function SWFLoader() 
		{
		}
		
		public function load(url:String)
		{
			m_complete = false;
			m_loader = new Loader();
			var mRequest:URLRequest = new URLRequest(url);
			m_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			m_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			m_loader.load(mRequest);
		}

		function onCompleteHandler(loadEvent:Event)
		{
			m_complete = true;
			m_eventLoaded = loadEvent;
			FlxG.stage.addChild(m_loader);
		}
		
		function onProgressHandler(mProgress:ProgressEvent)
		{
			var percent:Number = mProgress.bytesLoaded/mProgress.bytesTotal;
			trace(percent);
		}
	}

}
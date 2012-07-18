package  
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Tom
	 */
	public class LoadXml 
	{
		public var m_xml:XML;
		protected var m_isComplete:Boolean = false;
		
		public function LoadXml(_url:String) 
		{
			var request:URLRequest = new URLRequest(_url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(request);
		}
		
		private function onComplete(e:Event) : void
		{
			m_xml = new XML(e.target.data);
			m_isComplete = true;
		}
		
		public function isComplete() : Boolean {
			return m_isComplete;
		}
	}

}
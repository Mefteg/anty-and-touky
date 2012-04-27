package Server 
{
	import flash.display.Sprite;
    import flash.events.*;
    import flash.net.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class URLRequestPHP extends Sprite 
	{
		public var m_loader:URLLoader;
		protected var m_complete:Boolean;
		
		public function URLRequestPHP(url:String, urlVar:URLVariables, method:String="GET") 
		{
			m_loader = new URLLoader();
            configureListeners(m_loader);

            var request:URLRequest = new URLRequest(Global.serverAddress+url);
			request.method = method;
			request.data = urlVar;
			
            try {
                m_loader.load(request);
            } catch (error:Error) {
                trace("Unable to load requested document.");
            }
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }

        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
			m_complete = true;
            //trace("completeHandler: " + loader.data);
        }

        private function openHandler(event:Event):void {
            //trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            //trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            //trace("securityErrorHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            //trace("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            //trace("ioErrorHandler: " + event);
        }
		
		public function isComplete() : Boolean {
			return m_complete;
		}
	}

}
package GameObject.Menu 
{
	import GameObject.DrawableObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class MyBackground extends DrawableObject 
	{
		public var m_nameMVC:String = "";

		protected var m_alreadyLoaded:Boolean;
		protected var m_origin:FlxPoint;
		
		public function MyBackground(_infos:Array) 
		{
			super(0, 0, null);
			m_url = _infos["backgroundImg"];
			m_width = _infos["size"].x;
			m_height = _infos["size"].y;
			m_name = _infos["name"];
			m_bufferGroup = DepthBuffer.s_backgroundGroup;
			
			m_origin = _infos["position"];
			this.x = m_origin.x;
			this.y = m_origin.y;
			
			m_alreadyLoaded = false;
		}
		
		public function setToOrigin() : void
		{
			this.x = m_origin.x;
			this.y = m_origin.y;
			this.x = 0;
			this.y = 480;
		}
		
		override public function update() : void {
			if ( Global.library.loadComplete() && m_alreadyLoaded == false ) {
				//Global.library.cacheObjects();
				this.load();
				m_alreadyLoaded = true;
			}
		}
		
		override public function destroy() : void {
			Global.currentState.depthBuffer.removeElement(this, m_bufferGroup);
		}
		
	}

}
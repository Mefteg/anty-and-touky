package GameObject.Menu 
{
	import GameObject.DrawableObject;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class MyBackground extends DrawableObject 
	{
		protected var m_alreadyLoaded:Boolean;
		
		public function MyBackground(_infos:Array) 
		{
			super(0, 0, null);
			m_url = _infos["backgroundImg"];
			m_width = _infos["size"].x;
			m_height = _infos["size"].y;
			m_bufferGroup = DepthBuffer.s_backgroundGroup;
			
			m_alreadyLoaded = false;
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
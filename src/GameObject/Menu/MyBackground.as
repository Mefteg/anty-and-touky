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
			m_width = _infos["sizex"];
			m_height = _infos["sizey"];
			m_bufferGroup = DepthBuffer.s_backgroundGroup;
			
			m_alreadyLoaded = false;
		}
		
		override public function update() : void {
			if ( Global.library.loadComplete() && m_alreadyLoaded == false ) {
				this.load();
				m_alreadyLoaded = true;
			}
		}
		
	}

}
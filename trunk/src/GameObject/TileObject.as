package GameObject 
{
	/**
	 * ...
	 * @author Tom
	 */
	public class TileObject extends DrawableObject 
	{
		static public var s_type:String = "TileObject";
		
		protected var m_index:uint;
		
		public function TileObject(X:Number=0, Y:Number=0, mapName:String=null, index:uint=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_url = mapName;
			m_width = Global.tile_width;
			m_height = Global.tile_height;
			m_index = index;
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_tileGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_tileGroup);
		}
		
		override public function load() : void {
			super.load();
			this.addAnimation(String(m_index), [m_index]);
			play(String(m_index));
		}
		
		public function action(object:GameObject.PhysicalObject) : void {
			if ( m_collide ) {
				trace("BLA!");
			}
		}
	}

}
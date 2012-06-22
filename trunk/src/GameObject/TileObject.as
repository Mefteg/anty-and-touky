package GameObject 
{
	/**
	 * ...
	 * @author Tom
	 */
	public class TileObject extends DrawableObject 
	{
		static public var s_type:String = "TileObject";
		
		protected var m_layer:uint; // 0 : Background ; 1 : Foreground
		protected var m_index:uint;
		
		public function TileObject(layer:uint=0, X:Number=0, Y:Number=0, mapName:String=null, index:uint=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_url = mapName;
			m_width = Global.tile_width;
			m_height = Global.tile_height;
			m_layer = layer;
			m_index = index;
		}
		
		override public function addToStage():void {
			if ( m_layer == 0 ) {
				Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_tileGroup);
			}
			if ( m_layer == 1 ) {
				Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_foregroundGroup);
			}
		}
		
		override public function removeFromStage():void {
			if ( m_layer == 0 ) {
				Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_tileGroup);
			}
			if ( m_layer == 1 ) {
				Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_foregroundGroup);
			}
		}
		
		override public function load() : void {
			super.load();
			this.addAnimation(String(m_index), [m_index]);
			play(String(m_index));
		}
		
		public function collideWith(object:GameObject.PhysicalObject) : Boolean {
			return false;
		}
	}

}
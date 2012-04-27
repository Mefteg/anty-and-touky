package GameObject 
{
	/**
	 * ...
	 * @author Tom
	 */
	public class TileObject extends DrawableObject 
	{
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
			Global.currentState.depthBuffer.addTile(this);
		}
		
		override public function removeFromStage():void {
			Global.currentState.depthBuffer.removeTile(this);
		}
		
		override public function load() : void {
			super.load();
			this.addAnimation(String(m_index), [m_index]);
			play(String(m_index));
		}
	}

}
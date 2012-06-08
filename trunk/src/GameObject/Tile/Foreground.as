package GameObject.Tile 
{
	import GameObject.TileObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Foreground extends TileObject 
	{
		static public var s_type:String = "Foreground";
		
		public function Foreground(X:Number=0, Y:Number=0, mapName:String=null, index:uint=0, SimpleGraphic:Class=null) 
		{
			super(1, X, Y, mapName, index, SimpleGraphic);
			this.m_typeName = s_type;
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_foregroundGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_foregroundGroup);
		}
	}

}
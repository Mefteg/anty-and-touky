package GameObject.Tile 
{
	import GameObject.TileObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Foreground extends TileObject 
	{
		
		public function Foreground(X:Number=0, Y:Number=0, mapName:String=null, index:uint=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, mapName, index, SimpleGraphic);
			
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.addForeground(this);
		}
	}

}
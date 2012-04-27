package GameObject.Tile 
{
	import GameObject.PhysicalTile;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Rock extends PhysicalTile
	{
		
		public function Rock(X:Number=0, Y:Number=0, mapName:String = null, index:uint=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, mapName, index, SimpleGraphic);
		}
		
	}

}
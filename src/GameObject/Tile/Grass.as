package GameObject.Tile 
{
	import GameObject.TileObject;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Grass extends TileObject 
	{
		
		public function Grass(X:Number=0, Y:Number=0, mapName:String = null, index:uint=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, mapName, index, SimpleGraphic);
		}		
	}

}
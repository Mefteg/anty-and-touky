package GameObject.Tile 
{
	import GameObject.TileObject;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Grass extends TileObject 
	{
		static public var s_type:String = "Grass";
		
		public function Grass(layer:uint, X:Number=0, Y:Number=0, mapName:String = null, index:uint=0, SimpleGraphic:Class=null) 
		{
			super(layer, X, Y, mapName, index, SimpleGraphic);
		}		
	}

}
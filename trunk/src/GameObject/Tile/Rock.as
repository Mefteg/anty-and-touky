package GameObject.Tile 
{
	import GameObject.PhysicalObject;
	import GameObject.PhysicalTile;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Rock extends PhysicalTile
	{
		static public var s_type:String = "Rock";
		
		public function Rock(X:Number=0, Y:Number=0, mapName:String = null, index:uint=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, mapName, index, SimpleGraphic);
		}
		
		override public function action(object:PhysicalObject) : void {
			
		}
	}

}
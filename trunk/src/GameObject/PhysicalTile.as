package GameObject 
{
	/**
	 * ...
	 * @author Tom
	 */
	public class PhysicalTile extends TileObject 
	{
		static public var s_type:String = "PhysicalTile";
		
		public function PhysicalTile(layer:uint, X:Number=0, Y:Number=0, mapName:String=null, index:uint=0, SimpleGraphic:Class=null) 
		{
			super(layer, X, Y, mapName, index, SimpleGraphic);
			m_collide = true;
			m_typeName = PhysicalTile.s_type;
		}
	}

}
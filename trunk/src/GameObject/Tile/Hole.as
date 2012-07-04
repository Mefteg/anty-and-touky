package GameObject.Tile 
{
	import GameObject.PhysicalObject;
	import GameObject.PhysicalTile;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Hole extends PhysicalTile 
	{
		static public var s_type:String = "Hole";
		
		public function Hole(layer:uint, X:Number=0, Y:Number=0, mapName:String=null, index:uint=0, SimpleGraphic:Class=null) 
		{
			super(layer, X, Y, mapName, index, SimpleGraphic);
			this.m_typeName = s_type;
		}
		
		/*override public function action(object:PhysicalObject) : void {
			object.m_canGoThrough = false;
			var center:FlxPoint = object.getCenter();
			if ( center.x > this.x && center.x < (this.x + m_width) ) {
				if ( center.y > this.y && center.y < (this.y + m_height) ) {
					object.respawn();
				}
			}
		}*/
		
		override public function collideWith(object:GameObject.PhysicalObject) : Boolean {
			// Touky can fly
			if ( object == Global.player2 ) {
				return false;
			}
			
			return true;
		}
	}

}
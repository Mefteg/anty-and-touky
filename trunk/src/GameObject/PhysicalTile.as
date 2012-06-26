package GameObject 
{
	import org.flixel.FlxPoint;
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
		
		override public function collideWith(object:GameObject.PhysicalObject) : Boolean {
			/*var topleft:FlxPoint = new FlxPoint(object.x + object.m_hitbox.x, object.y + object.m_hitbox.y);
			var topright:FlxPoint = new FlxPoint(topleft.x + object.m_hitbox.width, object.y + object.m_hitbox.y);
			var bottomright:FlxPoint = new FlxPoint(topright.x, topleft.y + object.m_hitbox.height);
			var bottomleft:FlxPoint = new FlxPoint(topleft.x, bottomright.y);
			
			var tl:FlxPoint = new FlxPoint(topleft.x - x, topleft.y - y);
			var tr:FlxPoint = new FlxPoint(topright.x - x, topright.y - y);
			var br:FlxPoint = new FlxPoint(bottomright.x - x, bottomright.y - y);
			var bl:FlxPoint = new FlxPoint(bottomleft.x - x, bottomleft.y - y);
			
			var tl_color:uint = this.framePixels.getPixel32(tl.x, tl.y);
			var tr_color:uint = this.framePixels.getPixel32(tr.x, tr.y);
			var br_color:uint = this.framePixels.getPixel32(br.x, br.y);
			var bl_color:uint = this.framePixels.getPixel32(bl.x, bl.y);

			if ( tl_color != 0 ) {
				trace("color at tl " + tl.x + ", " + tl.y + ": " + tl_color.toString(16));
				return true;
			}
			if ( tr_color != 0 ) {
				trace("color at tr " + tr.x + ", " + tr.y + ": " + tr_color.toString(16));
				return true;
			}
			if ( br_color != 0 ) {
				trace("color at br " + br.x + ", " + br.y + ": " + br_color.toString(16));
				return true;
			}
			if ( bl_color != 0 ) {
				trace("color at bl " + bl.x + ", " + bl.y + ": " + bl_color.toString(16));
				return true;
			}
			
			return false;*/
			
			return true;
		}
	}

}
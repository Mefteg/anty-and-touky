package GameObject.Menu 
{
	import GameObject.GameObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class MenuShield extends SubMenu 
	{
		
		public function MenuShield(player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(player, X, Y, SimpleGraphic);
			
		}
		
		override protected function create() : void {
			this.addIcon();
			this.addIcon();
		}
		
		override public function addIcon() : void {
			super.addIcon();
			var obj:GameObject = new Icon(this.x, this.y);
			obj.m_url = "Images/Menu/icon_shield_basic.png";
			obj.m_width = 12;
			obj.m_height = 14;
			obj.m_parent = this;
			obj.m_shift = new FlxPoint(12, 8);
			Global.library.addUniqueBitmap(obj.m_url);
			this.add(obj);
			
			obj.m_shift.x = (m_objects.length - 1) * obj.m_width;
		}
		
	}

}
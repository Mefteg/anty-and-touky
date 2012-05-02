package GameObject.Menu 
{
	import GameObject.GameObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class MenuHeart extends SubMenu 
	{
		
		public function MenuHeart(player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(player, X, Y, SimpleGraphic);
		}
		
		override protected function create() : void {
			var obj:GameObject;
			// adding of the heart icon
			obj = new Icon(this.x, this.y);
			obj.m_parent = this;
			obj.m_shift = new FlxPoint(10, 8);
			Global.library.addUniqueBitmap(obj.m_url);
			this.add(obj);
			
			// adding of the heart icon
			obj = new Icon(this.x, this.y);
			obj.m_parent = this;
			obj.m_shift = new FlxPoint(19, 8);
			Global.library.addUniqueBitmap(obj.m_url);
			this.add(obj);
			
			// adding of the heart icon
			obj = new Icon(this.x, this.y);
			obj.m_parent = this;
			obj.m_shift = new FlxPoint(28, 8);
			Global.library.addUniqueBitmap(obj.m_url);
			this.add(obj);
		}
		
	}

}
package GameObject.Menu 
{
	import GameObject.CompositeObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MenuIncremental extends SubMenu 
	{
		public var m_cursor:GameObject.Menu.Cursor;
		
		public function MenuIncremental(cursor:Cursor, player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			m_cursor = cursor;
			super(null, X, Y, SimpleGraphic);
		}
		
		override protected function create() : void {
			// adding of the minus button
			var button1:Button = new ButtonMinus(m_cursor, null, this.x, this.y);
			button1.m_shift = new FlxPoint(0, 0);
			button1.m_parent = this;
			Global.library.addUniqueBitmap(button1.m_url);
			this.add(button1);
			
			// adding the incremental text ( :-O )
			
			// adding of the option button
			var button2:Button = new ButtonPlus(m_cursor, null, this.x, this.y);
			button2.m_shift = new FlxPoint(100, 0);
			button2.m_parent = this;
			Global.library.addUniqueBitmap(button2.m_url);
			this.add(button2);
			
			button1.m_next = button2;
			button2.m_next = button1;
		}		
	}

}
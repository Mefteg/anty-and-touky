package GameObject.Menu 
{
	import GameObject.Armor.Armor;
	import GameObject.CompositeObject;
	import GameObject.GameObject;
	import GameObject.Magic.Magic;
	import GameObject.PlayableObject;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class ButtonMenuMagic extends ButtonMenu 
	{
		private var m_waitEnough:Boolean;
		
		public function ButtonMenuMagic(cursor:Cursor, player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			m_cursor = cursor;
			super(player, X, Y, SimpleGraphic);
			m_waitEnough = false;
		}
		
		override protected function create() : void {
			var obj:Button;
			
			var magics:Vector.<Magic> = m_player.m_magics;
			for ( var i:int = 0; i < magics.length; i++ ) {
				this.addMagicWithoutLoad(i);
			}
		}
		
		protected function addMagicWithoutLoad(i:int) : void {
			var magics:Vector.<Magic> = m_player.m_magics;
			var obj:ButtonMagicAction = new ButtonMagicAction(i, m_cursor, m_player, this.x, this.y);

			obj.m_url = magics[i].m_iconImage;
			obj.m_shift = new FlxPoint((m_objects.length * 20), 0);
			obj.m_parent = this;
			this.add(obj);
			// if the magic menu has more than one button
			if ( m_objects.length > 1 ) {
				var lastButton:Button = m_objects[m_objects.length - 2] as GameObject.Menu.Button;
				// if the other buttons are visible
				if ( lastButton.visible ) {
					obj.display();
				}
				else {
					obj.hide();
				}
				
				lastButton.m_next = obj;
				obj.m_next = m_objects[0] as Button;
			}
			else {
				obj.m_next = obj;
				obj.hide();
			}
		}
		
		public function addMagic(i:int) : void {
			var magics:Vector.<Magic> = m_player.m_magics;
			var obj:ButtonMagicAction = new ButtonMagicAction(i, m_cursor, m_player, this.x, this.y);

			obj.m_url = magics[i].m_iconImage;
			obj.m_shift = new FlxPoint((m_objects.length * 20), 0);
			obj.m_parent = this;
			obj.load();
			obj.addToStage();
			this.add(obj);
			// if the magic menu has more than one button
			if ( m_objects.length > 1 ) {
				var lastButton:Button = m_objects[m_objects.length - 2] as GameObject.Menu.Button;
				// if the other buttons are visible
				if ( lastButton.visible ) {
					obj.display();
				}
				else {
					obj.hide();
				}
				
				lastButton.m_next = obj;
				obj.m_next = m_objects[0] as Button;
			}
			else {
				obj.m_next = obj;
				obj.hide();
			}
		}
	}

}
package GameObject.Menu 
{
	import GameObject.PlayableObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ButtonItem extends Button 
	{
		
		private var m_menuItem:ButtonMenuItem;
		private var m_firstActionDone:Boolean = false;
		
		public function ButtonItem(cursor:Cursor, player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(cursor, player, X, Y, SimpleGraphic);
			m_url = "Images/Menu/icon_item_basic.png";
			
			m_menuItem = new ButtonMenuItem(cursor, m_player);
			m_menuItem.m_parent = this;
			m_menuItem.m_shift = new FlxPoint(0, 20);
			m_menuItem.hide();
			
			if ( m_player.toString() == "Player1" ) {
				Global.buttonMenuItemPlayer1 = m_menuItem;
			}
			else {
				Global.buttonMenuItemPlayer2 = m_menuItem;
			}
		}
		
		override public function validate() : void {
			if ( !m_firstActionDone ) {
				m_menuItem.addToStage();
				//m_menuItem.load();
				
				m_firstActionDone = true;
			}
			
			if ( !m_menuItem.isEmpty() ) {
				// display the magic menu
				m_menuItem.display();
				
				// get back the first magic action button
				var button:Button = m_menuItem.getFirst() as Button;
				m_cursor.m_currentButton = button;
			}
		}
		
		override public function cancel() : void {
			super.cancel();
			m_menuItem.hide();
		}
	}
}
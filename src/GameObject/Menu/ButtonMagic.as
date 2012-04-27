package GameObject.Menu 
{
	import GameObject.PlayableObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class ButtonMagic extends Button 
	{
		private var m_menuMagic:ButtonMenuMagic;
		private var m_firstActionDone:Boolean = false;
		
		public function ButtonMagic(cursor:Cursor, player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(cursor, player, X, Y, SimpleGraphic);
			m_url = "Images/Menu/icon_rod_basic.png";
			
			m_menuMagic = new ButtonMenuMagic(cursor, m_player);
			m_menuMagic.m_parent = this;
			m_menuMagic.m_shift = new FlxPoint(0, 20);
			m_menuMagic.hide();
			
			if ( m_player.toString() == "Player1" ) {
				Global.buttonMenuMagicPlayer1 = m_menuMagic;
			}
			else {
				Global.buttonMenuMagicPlayer2 = m_menuMagic;
			}
		}
		
		override public function validate() : void {
			if ( !m_firstActionDone ) {
				m_menuMagic.addToStage();
				m_menuMagic.load();
				
				m_firstActionDone = true;
			}
			
			if ( !m_menuMagic.isEmpty() ) {
				// display the magic menu
				m_menuMagic.display();
				
				// get back the first magic action button
				var button:Button = m_menuMagic.getFirst() as Button;
				m_cursor.m_currentButton = button;
			}
		}
		
		override public function cancel() : void {
			super.cancel();
			m_menuMagic.hide();
		}
	}

}
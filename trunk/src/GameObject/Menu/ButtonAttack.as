package GameObject.Menu 
{
	import GameObject.PlayableObject;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class ButtonAttack extends Button 
	{
		
		public function ButtonAttack(cursor:Cursor, player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(cursor, player, X, Y, SimpleGraphic);
			m_url = "Images/Menu/icon_sword_basic.png";
		}
		
		override public function validate() : void {
			m_player.attack();
			m_cursor.m_currentButton = m_cursor.m_firstButton;
		}
	}

}
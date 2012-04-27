package GameObject.Menu 
{
	import GameObject.PlayableObject;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class ButtonMagicAction extends Button 
	{
		protected var m_magicId:int = 0;
		public function ButtonMagicAction(magicId:int, cursor:Cursor, player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(cursor, player, X, Y, SimpleGraphic);
			m_magicId = magicId;
			m_width = 16;
			m_height = 16;
		}
		
		override public function validate() : void {
			m_player.magicAttack(m_magicId);
			m_cursor.m_currentButton = m_cursor.m_firstButton;
			m_parent.hide();
		}
		
		override public function cancel() : void {
			super.cancel();
			m_parent.hide();
		}
		
	}

}
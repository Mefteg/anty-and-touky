package GameObject.Menu 
{
	import GameObject.PlayableObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ButtonMinus extends Button 
	{
		
		public function ButtonMinus(cursor:Cursor, player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(cursor, player, X, Y, SimpleGraphic);
			m_url = "Images/Menu/icon_minus.png";
			m_width = 50;
			m_height = 50;
		}
		
		override public function validate() : void {
			Global.nbLifesMax--;
			if ( Global.nbLifesMax < 1 ) {
				Global.nbLifesMax = 1;
			}
			
			trace(Global.nbLifesMax);
		}
	}

}
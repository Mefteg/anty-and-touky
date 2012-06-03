package GameObject.Menu 
{
	import GameObject.PlayableObject;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ButtonBack extends Button 
	{
		
		public function ButtonBack(cursor:Cursor, player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(cursor, player, X, Y, SimpleGraphic);
			m_url = "Images/Menu/optionsstate_back.png";
			m_width = 200;
			m_height = 50;
		}
		
		override public function validate() : void {
			FlxG.switchState( new Menustate() );
		}
		
	}

}
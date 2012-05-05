package GameObject.Menu 
{
	import GameObject.PlayableObject;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class ButtonPlay extends Button 
	{
		
		public function ButtonPlay(cursor:Cursor, player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(cursor, player, X, Y, SimpleGraphic);
			m_url = "Images/Menu/menustate_play.png";
			m_width = 200;
			m_height = 50;
			m_selected = false;
			m_player = player;
			m_cursor = cursor;
		}
		
		override public function validate() : void {
			FlxG.switchState( new Playstate() );
		}
		
	}

}
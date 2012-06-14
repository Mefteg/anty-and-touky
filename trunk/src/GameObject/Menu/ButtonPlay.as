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
		var m_nbPlayers:int;
		public function ButtonPlay(cursor:Cursor, player:PlayableObject,nbPlayers:int=1, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(cursor, player, X, Y, SimpleGraphic);
			if(nbPlayers ==1)
				m_url = "Images/Menu/menustate_play.png";
			else
				m_url = "Images/Menu/menustate_play2.png";
			m_width = 200;
			m_height = 50;
			m_selected = false;
			m_player = player;
			m_cursor = cursor;
			m_nbPlayers = nbPlayers;
		}
		
		override public function validate() : void {
			Global.nbPlayers = m_nbPlayers;
			Global.currentState.end();
		}
		
	}

}
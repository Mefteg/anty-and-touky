package GameObject.Enemy 
{
	import GameObject.IAObject;
	import GameObject.Player.Player1;
	import GameObject.Player.Player2;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import GameObject.Enemy.Enemy;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class WhiteSquare extends Enemy 
	{
		
		public function WhiteSquare(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_width = 32;
			m_height = 32;
			m_speed = 2;
			m_state = "lookfor";
			m_url = "Images/Enemies/WhiteSquare.png";
		}
				
	}

}
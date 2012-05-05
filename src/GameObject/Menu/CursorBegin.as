package GameObject.Menu 
{
	import GameObject.PlayableObject;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CursorBegin extends Cursor 
	{
		
		public function CursorBegin(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(null, X, Y, SimpleGraphic);
			m_url = "Images/Menu/menustate_cursor.png";
			m_width = 200;
			m_height = 50;
		}
		
		override protected function catchEvent() : void {
			if ( m_enabled ) {
				if ( FlxG.keys.justPressed("F") ) {
					m_currentButton.validate();
				}
				
				if ( FlxG.keys.justPressed("S") ) {
					m_currentButton.next();
				}

				if ( FlxG.keys.justPressed("G") ) {
					m_currentButton.cancel();
				}
			}
		}
	}

}
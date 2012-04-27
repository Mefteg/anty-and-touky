package GameObject.Menu 
{
	import GameObject.DrawableObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Cursor extends DrawableObject 
	{
		public var m_enabled:Boolean = true;
		public var m_currentButton:Button;
		public var m_firstButton:Button;
		
		protected var m_player:PlayableObject;
		
		public function Cursor(player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_url = "Images/Menu/cursor.png";
			m_width = 16;
			m_height = 16;
			m_player = player;
		}
		
		override public function update() : void {
			super.update();
			
			this.catchEvent();
			
			this.place();
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.addCursor(this);
		}
		
		protected function catchEvent() : void {
			if ( m_enabled ) {
				if ( FlxG.keys.justPressed(m_player.getButtonValidate()) ) {
					m_currentButton.validate();
				}
				
				if ( FlxG.keys.justPressed(m_player.getButtonNext()) ) {
					m_currentButton.next();
				}

				if ( FlxG.keys.justPressed(m_player.getButtonPrevious()) ) {
					m_currentButton.cancel();
				}
			}
		}
		
		// Place the cursor on the button
		protected function place() : void {
			this.x = m_currentButton.x;
			this.y = m_currentButton.y;
		}
		
		public function setEnabled(enable:Boolean) : void {
			m_enabled = enable;
		}
	}
}
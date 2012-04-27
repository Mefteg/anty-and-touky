package GameObject.Menu 
{
	import GameObject.DrawableObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class FrameMenu extends DrawableObject 
	{
		
		public function FrameMenu(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_url = "Images/Menu/menu_frame.png";
			m_width = 120;
			m_height = 45;
			
			m_shift = new FlxPoint(0, 0);
		}
		
		override public function update() : void {
			// placement
			if ( m_parent != null ) {
				this.x = m_parent.x + m_shift.x;
				this.y = m_parent.y + m_shift.y;
			}
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.addMenu(this);
		}
	}
}
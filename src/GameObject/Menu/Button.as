package GameObject.Menu 
{
	import GameObject.DrawableObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Button extends DrawableObject 
	{
		public var m_selected:Boolean;
		
		protected var m_player:PlayableObject;
		
		public var m_next:Button;
		
		public var m_cursor:Cursor;
		
		public function Button(cursor:Cursor, player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_url = "Images/Menu/icon_sword_basic.png";
			m_width = 16;
			m_height = 16;
			m_selected = false;
			m_player = player;
			m_cursor = cursor;
		}
		
		override public function update() : void {
			super.update();
			// placement
			if ( m_parent != null ) {
				this.x = m_parent.x + m_shift.x;
				this.y = m_parent.y + m_shift.y;
			}
		}
		
		public function validate() : void {
			
		}
		
		public function next() : void {
			m_cursor.m_currentButton = m_next;
		}
		
		public function cancel() : void {
			m_cursor.m_currentButton = m_cursor.m_firstButton;
		}
		
		public function drawRect() : void {
			this.drawLine(0, 0, m_width, 0, FlxG.BLACK, 2);
			this.drawLine(m_width, 0, m_width, m_height, FlxG.BLACK, 2);
			this.drawLine(0, m_height, m_width, m_height, FlxG.BLACK, 2);
			this.drawLine(0, 0, 0, m_height, FlxG.BLACK, 2);
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.addElement(this, DepthBuffer.s_menuGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentState.depthBuffer.removeElement(this, DepthBuffer.s_menuGroup);
		}
	}

}
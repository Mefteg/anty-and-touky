package GameObject.Menu 
{
	import GameObject.DrawableObject;
	import GameObject.PlayableObject;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Icon extends DrawableObject 
	{
		
		public function Icon(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_url = "Images/Menu/icon_heart_basic.png";
			m_width = 9;
			m_height = 9;
		}
		
		override public function update() : void {
			super.update();
			// placement
			if ( m_parent != null ) {
				this.x = m_parent.x + m_shift.x;
				this.y = m_parent.y + m_shift.y;
			}
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.addElement(this, DepthBuffer.s_menuGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentState.depthBuffer.removeElement(this, DepthBuffer.s_menuGroup);
		}
	}

}
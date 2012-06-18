package GameObject.Other 
{
	import GameObject.DrawableObject;
	/**
	 * ...
	 * @author ...
	 */
	public class BoxHole extends DrawableObject
	{
		
		public function BoxHole(X:Number,Y:Number ) 
		{
			super(X, Y);
			m_state = "idle";
			m_name = "BoxHole";
			m_url = "Images/Others/boxHole.png";
			m_width = 32; m_height = 32;
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.addHoleBox(this);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_nppGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_nppGroup);
		}
		
	}

}
package GameObject.Other 
{
	import GameObject.DrawableObject;
	/**
	 * ...
	 * @author ...
	 */
	public class BoxHole extends DrawableObject
	{
		private var m_target:String;
		
		public function BoxHole(X:Number,Y:Number,target:String) 
		{
			super(X, Y);
			m_state = "idle";
			m_name = "BoxHole";
			m_url = "Images/Others/boxHole.png";
			m_width = 32; m_height = 32;
			m_target = target;
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.addHoleBox(this);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function act():void {
			var door:Door = Global.currentPlaystate.getDoor(m_target);
			if (door)
				door.act();
		}
		
	}

}
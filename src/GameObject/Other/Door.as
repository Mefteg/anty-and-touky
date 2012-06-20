package GameObject.Other 
{
	import GameObject.PhysicalObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Door extends PhysicalObject 
	{
		
		public function Door(X:Number, Y:Number, name:String ) 
		{
			super(X, Y);
			m_url = "Images/Others/spikes.png";
			m_name = name;
			m_width = 48; m_height = 48;
		}
		override public function addToStage():void {
			Global.currentPlaystate.addPhysical(this as PhysicalObject);
			Global.currentPlaystate.addDoor(this);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.removeDoor(this);
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function act():void {
			m_collideWithObjects = false;
			frame = 1;
		}
	}

}
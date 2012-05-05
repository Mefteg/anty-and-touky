package GameObject 
{
	/**
	 * ...
	 * @author Tom
	 */
	public class IAObject extends PhysicalObject 
	{
		
		public function IAObject(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			
		}
		
		override public function addToStage() : void {
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_enemyGroup);
		}
	}

}
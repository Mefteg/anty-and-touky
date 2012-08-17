package GameObject.Other 
{
	import GameObject.DrawableObject;
	/**
	 * ...
	 * @author ...
	 */
	public class BoxHole extends Switch
	{
		
		public function BoxHole(X:Number,Y:Number,target:String) 
		{
			super(X, Y, target,0);
			m_name = "BoxHole";
			m_url = "Images/Others/boxHole.png";
			m_width = 32; m_height = 32;
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.addHoleBox(this);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function update():void { }
		
		public static function BarrelHole(X:Number, Y:Number, target:String) : BoxHole {
			var bh:BoxHole = new BoxHole(X, Y, target);
			bh.m_url = "Images/Others/barrelHole.png";
			return bh;
		}
		
	}

}
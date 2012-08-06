package GameObject.Other 
{
	import GameObject.Menu.MVCButton;
	import GameObject.MovableObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AnimatedObject extends MovableObject 
	{
		private var speedAnim:int = 5;
		
		public function AnimatedObject(X:Number,Y:Number) 
		{
			super(X, Y);
			m_bufferGroup = DepthBufferPlaystate.s_objectGroup;
		}
		
		public function setAnimSpeed(spd:int):void {
			speedAnim = spd;
		}
		
		public function setAnimation(...rest):void {
			addAnimation("idle", rest, speedAnim, true);
			play("idle");
		}
		
		public static function Alarm(X:Number, Y:Number):AnimatedObject {
			var alarm:AnimatedObject = new AnimatedObject(X, Y);
			alarm.m_url = "Images/Others/alarm.png";
			alarm.m_width = 32; alarm.m_height = 32;
			alarm.setAnimSpeed(2);
			alarm.setAnimation(0, 0, 0,0, 1,1);
			return alarm;
		}
	}

}
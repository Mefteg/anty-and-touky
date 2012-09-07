package GameObject.Other.Clouds 
{
	import GameObject.MovableObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Cloud extends MovableObject 
	{
		
		public function Cloud() 
		{
			super(0, 0);
			if(Utils.random(0,100) < 50)
				m_url = "Images/Others/cloud1.png";
			else
				m_url = "Images/Others/cloud2.png";
			m_height = 96; m_width = 128;
			m_state = "ready";
			m_direction = new FlxPoint( -1, 0);
			m_directionFacing = m_direction;
			alpha = 0.3;
			m_bufferGroup = DepthBufferPlaystate.s_foregroundGroup;
		}
		
		public function isReady():Boolean {
			return m_state == "ready";
		}
		
		public function spawn(X:Number, Y:Number, speed:Number) :void {
			x = X; y = Y;
			m_speed = speed;
			m_state = "moving";
			addToStage();
		}
		
		override public function update():void {
			switch(m_state) {
				case "moving" : move();
								if ( ! onScreen()){
									m_state = "ready";
									removeFromStage();
								}
								break;
			}
		}
		
		
	}

}
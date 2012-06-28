package GameObject.Other 
{
	import GameObject.DrawableObject;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class Switch extends DrawableObject
	{
		protected var m_active:Boolean = false;
		private var m_target:String;
		private var m_time:int;
		private var m_timerClose:FlxTimer;
		
		public function Switch(X:Number,Y:Number,target:String,time:int) 
		{
			super(X, Y);
			m_state = "idle";
			m_name = "Switch";
			m_url = "Images/Others/switch.png";
			m_width = 32; m_height = 32;
			m_target = target;
			m_time = time;
			m_timerClose = new FlxTimer();
			
			if (m_time == 0 || !Global.soloPlayer)
				m_timerClose.start(0.1);
		}
				
		override public function addToStage():void {
			//Global.currentPlaystate.addHoleBox(this);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function act():void {
			var door:Door = Global.currentPlaystate.getDoor(m_target);
			if (door)
				door.act();	
			frame = 1;
			m_active = true;
		}
		
		public function close():void {
			var door:Door = Global.currentPlaystate.getDoor(m_target);
			if (door)
				door.close();	
			frame = 0;
			m_active = false;
			m_state = "idle";
		}
		
		override public function update():void {
			switch(m_state){
				case "idle" :if (!m_active && collide(Global.player1)){
								act();
							}else if (m_active && !collide(Global.player1)) {
								m_state = "timer";
								if(m_time >0)
									m_timerClose.start(m_time);
							}
							break;
				case "timer": if ( m_timerClose.finished) {
									close();
								} break;
			}
		}
	}

}
package GameObject.Other 
{
	import GameObject.PhysicalObject;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class HorizontalPillar extends PhysicalObject 
	{
		private var m_timerAttack:FlxTimer;
		private var m_initX:Number;
		private var m_timeWait:Number;
		
		public function HorizontalPillar(object:Object) 
		{
			super(object.x, object.y);
			m_url = "Images/Others/pillarHoriz.png";
			m_width = 128; m_height = 32;
			x -= 125;
			m_initX = x;
			m_timerAttack = new FlxTimer();
			m_timerAttack.start(object.properties.timeGo);
			m_direction.y = 0;
			if (object.properties.left != null) {
				scale.x = -1;
				m_direction.x = -1;
			}else{
				m_direction.x = 1;
			}
			if (object.properties.wait)
				m_timeWait = object.properties.wait;
			else
				m_timeWait = 2;
			m_bufferGroup = DepthBufferPlaystate.s_objectGroup;
			m_state = "idle";
			m_weight = 20;
		}
		
		function attack():void {
			m_speed = 5;
			move();
			checkPlayersDamage();
			if ( Math.abs(x - m_initX) >= 128) {
				triggerRetract();
			}
		}
		
		function retract():void {
			move();
			if (m_direction.x > 0) {
				if (x >= m_initX) {
					m_state = "idle";
					m_timerAttack.start(m_timeWait);
					x = m_initX;
					m_direction.x *= -1;
				}
			}else {
				if (x <= m_initX) {
					m_state = "idle";
					m_timerAttack.start(m_timeWait);
					x = m_initX;
					m_direction.x *= -1;
				}
			}
		}
		
		function checkPlayersDamage():void {
			if (Global.soloPlayer) {
				if ( (m_direction.x > 0 && Global.soloPlayer.collideFromLeft(this) ) || 
						(m_direction.x < 0 && Global.soloPlayer.collideFromRight(this)) )
				{
					Global.soloPlayer.takeDamage();
					triggerRetract();
				}
				return;
			}
			
			var hit:Boolean = false;
			
			if ( (m_direction.x > 0 && Global.player1.collideFromLeft(this)) || 
						(m_direction.x < 0 && Global.player1.collideFromRight(this) ))
			{
				Global.player1.takeDamage();
				hit = true;
			}
			if ( (m_direction.x > 0 && Global.player2.collideFromLeft(this)) || 
						(m_direction.x < 0 && Global.player2.collideFromRight(this) ))
			{
				Global.player2.takeDamage();
				hit = true;
			}
			
			if (hit)
				triggerRetract();
		}
		
		override public function update():void {
			if (Global.frozen)
				return;
			switch(m_state) {
				case "idle" : if (m_timerAttack.finished) m_state = "attack"; break;
				case "attack": attack(); break;
				case "retract" : retract(); break;
				default : break;
			}
		}
		
		function triggerRetract():void {
			m_state = "retract";
			m_speed = 3.5;
			m_direction.x *= -1;
		}
		
		override public function addToStage():void {
			super.addToStage();
			Global.currentPlaystate.addPhysical(this as PhysicalObject);
		}
		
		override public function move() : void {
			m_oldPos.x = x; //m_oldPos.y = y;
			this.x = this.x + (m_direction.x * m_speed);
			//this.y = this.y + (m_direction.y * m_speed);
		}
		
	}

}
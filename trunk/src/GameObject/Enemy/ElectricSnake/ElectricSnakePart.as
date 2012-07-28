package GameObject.Enemy.ElectricSnake 
{
	import GameObject.Enemy.Enemy;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ElectricSnakePart extends Enemy 
	{
		private var m_initX:Number;
		private var m_angle:Number;
		
		public function ElectricSnakePart(X:Number,Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Enemies/ElectricSnake/body.png";
			m_width = 48; m_height = 48;
			m_invincible = true;
			m_collideEvtFree = true;
			scale.x = 0.8; scale.y = 0.8;
			m_initX = x;
			m_angle = 0;
			setHitbox(10, 10, 30, 30);
		}
		
		override public function load():void {
			super.load();
			addAnimation("idle", [0, 1, 2], 10, true);
			play("idle");
		}
		
		override public function update():void {
			if (m_timerDeath.finished && m_state != "anihilated")
				die();
			m_angle+=Utils.random(0.05,0.2);
			x = m_initX + Math.sin(m_angle)*5;
		}
		
		public function triggerDeath(time:Number):void {
			m_timerDeath.start(time);
		}
	}

}
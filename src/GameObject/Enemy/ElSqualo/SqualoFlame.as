package GameObject.Enemy.ElSqualo 
{
	import GameObject.Enemy.Enemy;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SqualoFlame extends Enemy 
	{
		var m_id:int;
		var m_arm:SqualoRightArm;
		
		var m_targetPos:FlxPoint;
		var FLAME_OFFSET:int = 10;
		
		var m_arrived:Boolean = false;
		
		public function SqualoFlame(id:int,arm:SqualoRightArm) 
		{
			super(80, 80);
			m_url = "Images/Enemies/ElSqualo/flame.png";
			m_width = 32; m_height = 32;
			
			m_arm = arm;
			m_id = id;
			m_state = "idle";
			
			m_invincible = true;
		}
		
		public function moveTo(target:FlxPoint):void {
			m_state = "movingTo";
			m_targetPos = target;
			goToPoint(m_targetPos);
			m_arrived = false;
			m_speed = 5;
		}
		
		private function movingTo():void {
			if (isArrived())
				m_state = "idle";
			goToPoint(m_targetPos);
			move();
		}
		
		private function isArrived():Boolean {
			if (m_arrived)
				return true;
			if (x < m_targetPos.x +1 && x > m_targetPos.x-1 && y<m_targetPos.y+1 && y>m_targetPos.y-1)
				return true;
			return false;
		}
		
		override public function update():void {
			commonEnemyUpdate();
			switch(m_state) {
				case "movingTo":movingTo(); break;
				default : break;
			}
		}
		
		override public function load():void {
			super.load();
			addAnimation("burn", [0, 1], 10, true);
			play("burn");
		}
		
		override public function move() : void {
			m_oldPos.x= this.x;
			m_oldPos.y = this.y;
			
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
			
			if(!m_collideEvtFree){
				if ( this.collideWithEnv() ) {
					m_arrived = true;
					this.x = m_oldPos.x;
				}
				if ( this.collideWithEnv() ) {
					m_arrived = true;
					this.y = m_oldPos.y;
				}
			}
		}
		
	}

}
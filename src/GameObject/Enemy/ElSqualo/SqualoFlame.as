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
		
		public function SqualoFlame(id:int,arm:SqualoRightArm) 
		{
			super(80, 80);
			m_url = "Images/Enemies/ElSqualo/flame.png";
			m_width = 32; m_height = 32;
			
			m_arm = arm;
			m_id = id;
			m_state = "idle";
		}
		
		public function moveTo(target:FlxPoint):void {
			m_state = "movingTo";
			m_targetPos = target;
			goToPoint(m_targetPos);
			m_speed = 5;
		}
		
		private function movingTo():void {
			if (isArrived()){
				m_state = "idle";
			}
			
			goToPoint(m_targetPos);
			move();
		}
		
		private function isArrived():Boolean {
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
	}

}
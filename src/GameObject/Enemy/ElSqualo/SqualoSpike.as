package GameObject.Enemy.ElSqualo 
{
	import GameObject.Enemy.Enemy;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class SqualoSpike extends Enemy
	{
		var m_id:int;
		var m_arm:SqualoLeftArm;
		
		var m_positionArrayIdle:FlxPoint;
		var m_positionArrayAttack:FlxPoint;
		static var m_offset:int = 2;
		
		public function SqualoSpike(id:int,arm:SqualoLeftArm) 
		{
			m_id = id;
			createPosArray();
			createHitbox();
			m_arm = arm;
			m_url = "Images/Enemies/ElSqualo/spikes.png";
			m_width = 32; m_height = 32;
			m_speed = 4;
			m_state = "idle";
		}
		
		private function moving():void {
			commonEnemyUpdate();
			move();
		}
		
		private function placeFromArm():void {
			if (m_state == "idle") {
				x = m_arm.x + m_positionArrayIdle.x; y = m_arm.y + m_positionArrayIdle.y;
			}else if (m_state == "prepare") {
				x = m_arm.x + m_positionArrayAttack.x; y = m_arm.y + m_positionArrayAttack.y;
			}
		}
		
		public function prepare():void {
			m_state = "prepare";
			frame = 1 + m_id * m_offset;
			m_timerAttack.start(1);
		}
		
		public function getBack():void {
			m_state = "idle";
			frame = m_id * m_offset;
		}
		
		override public function attack():void {
			m_state == "moving";
		}
		
		override public function update():void {
			switch(m_state) {
				case "idle" : placeFromArm(); break;
				case "prepare": placeFromArm();
								if (m_timerAttack.finished)
									m_state = "moving";
								break;
				case "moving" : moving(); break;
				default : placeFromArm(); break;
			}
		}
		
		private function createHitbox():void {
			switch(m_id) {
				case 0 : setHitbox(0, 0, 18, 18);
						m_direction = Utils.normalize(new FlxPoint( -1, 1));
						break;
				case 1 : setHitbox(11, 0, 9, 24);
						m_direction = new FlxPoint(0, 1);
						break;
				case 2 : setHitbox(12, 3, 16, 16);
						m_direction = Utils.normalize(new FlxPoint( 1, 1));
						break;
			}
		}
		
		override public function load():void {
			super.load();
			frame = m_id * m_offset;
		}
		
		private function createPosArray():void {
			switch(m_id) {
				case 0 :m_positionArrayIdle = new FlxPoint(-6, 39);
						m_positionArrayAttack = new FlxPoint(14, 46);
						break;
				case 1 :m_positionArrayIdle = new FlxPoint(1, 44);
						m_positionArrayAttack = new FlxPoint(21, 51);
						break;
				case 2 :m_positionArrayIdle = new FlxPoint(6, 46);
						m_positionArrayAttack = new FlxPoint(30, 46);
						break;
			}
			
		}
	}

}
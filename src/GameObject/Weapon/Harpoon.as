package GameObject.Weapon 
{
	import GameObject.PlayableObject;
	/**
	 * ...
	 * @author ...
	 */
	public class Harpoon extends EnemyThrowable 
	{
		private var m_hitboxes:Object;
		public function Harpoon() 
		{
			super(1.5, "Images/Weapons/harpoon.png", 2);
			m_fourDirection = true;
			m_width = 32; m_height = 32;
			setHitbox(6, 6, 20, 20);
			m_hitboxes = { "256" : new Hitbox(8, 0, 16, 16) ,
							"4096" : new Hitbox(8, 20, 16, 16) ,
							"16" : new Hitbox(20, 8, 16, 16) ,
							"1" : new Hitbox(0, 8, 16, 16) 			
						};
		}
		
		override public function attack(direction:int):void {
			super.attack(direction);
			var str:String = facing.toString();
			m_hitbox = m_hitboxes[str];
		}
		
		override protected function Reject(player:PlayableObject) : void {
			player.m_didDeflect = true;
			m_deflectPlayer = player;
			var dir:uint = player.facing;
			if(dir==RIGHT || dir==LEFT){
				m_direction.x = 0;
				if (player.m_state == "attack2"){
					m_direction.y = -1;
					facing = UP;
				}else {
					facing = DOWN;
					m_direction.y = 1;
				}
			}else {
				if (player.m_state == "attack2"){
					m_direction.x = -1;
					facing = LEFT;
				}else {
					facing = RIGHT;
					m_direction.x = 1;
				}
				m_direction.y = 0;
			}
			m_speed *= 1.5;
			m_state = "rejected";
			
			switch(facing) {
				case LEFT : frame = 3; break;
				case RIGHT : frame = 1; break;
				case UP : frame = 0; break;
				case DOWN : frame = 2; break;
			}
		}
		
	}

}
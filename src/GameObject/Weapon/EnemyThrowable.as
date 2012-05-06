package GameObject.Weapon 
{
	import GameObject.Enemy.Enemy;
	import GameObject.MovableObject;
	import GameObject.PlayableObject;
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyThrowable extends Throwable
	{
		
		public var m_enemy:Enemy;
		
		public function EnemyThrowable(power:int,url:String,speed:int = 10) 
		{
			super(power, url);
			m_speed = speed;
			m_state = "idle";			
			m_width = 24;
			m_height = 32;
		}
		
		override public function setCaster(object:MovableObject) : void {
			super.setCaster(object);
			m_enemy = object as Enemy;
		}
		
		override public function CheckDamageDealt():Boolean {
			var result:Boolean = false;
			//check players for damage
			if (collide(Global.player1)){
				Global.player1.takeDamage();
				result = true;
			}
			if (collide(Global.player2)){
				Global.player2.takeDamage();
				result = true;
			}
			return result;
		}
		
		public function CheckRejection():Boolean {
			if (Global.player1.getWeapon().isAttacking() && Global.player1.getWeapon().collide(this)) {
				Reject(Global.player1);
				return true;
			}
			if (Global.player2.getWeapon().isAttacking() && Global.player2.getWeapon().collide(this)) {
				Reject(Global.player2);
				return true;	
			}
			return false;
		}
		
		private function Reject(player:PlayableObject) : void {
			var dir:uint = player.facing;
			if(dir==RIGHT || dir==LEFT){
				m_direction.x = 0;
				m_direction.y = 1;
			}else {
				m_direction.x = 1;
				m_direction.y = 0;
			}
			m_speed *= 1.5;
			m_state == "rejected";
		}
		
		override public function update():void {
			switch(m_state) {
				case "idle" : return; break;
				//if attack is on
				case "attack" : //and object not on screen anymore
								if (!onScreen() || CheckDamageDealt()) {
									//deactivate the object
									touched();
								}
								CheckRejection();
								break;
				case "rejected": if (!onScreen())
									touched();
								break;
				default : break;
			}
			move();
		}
		
		/////////////////////////////////////////////////////
		//////////////////PRBUILDED ENEMY THROWABLES/////////
		////////////////////////////////////////////////////
		public static function Slipper() : EnemyThrowable{
			return new EnemyThrowable(1, "Images/Weapons/slipper.png", 2);
		}
	}

}
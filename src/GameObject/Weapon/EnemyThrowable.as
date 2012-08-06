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
		
		public function EnemyThrowable(power:int,url:String,speed:int = 4) 
		{
			super(power, url,speed );
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
			if ( Global.soloPlayer) {
				if (collide(Global.soloPlayer) && Global.soloPlayer.visible){
					Global.soloPlayer.takeDamage();
					return m_fragile;
				}
			}
			//check players for damage
			if (collide(Global.player1) && Global.player1.visible ) {
				Global.player1.takeDamage();
				result = m_fragile;
			}
			if (collide(Global.player2) && Global.player2.visible){
				Global.player2.takeDamage();
				result = m_fragile;
			}
			return result;
		}
		
		public function CheckRejection():Boolean {
			if (!m_fragile)
				return false;
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
			if (Global.frozen)
				return;
			m_canGoThrough = true;
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
		
		public static function PistolBullet():EnemyThrowable {
			var bullet:EnemyThrowable = new EnemyThrowable(1, "Images/Weapons/bullets.png", 2);
			bullet.m_width = 16; bullet.m_height = 16;
			bullet.setHitbox(6, 6, 4, 4);
			bullet.m_FXurl = "FX/pistol_fire.mp3";
			return bullet;
		}
		
		public static function CannonBullet():EnemyThrowable {
			var bullet:EnemyThrowable = new EnemyThrowable(1, "Images/Weapons/bulletCannon.png", 2);
			bullet.m_width = 16; bullet.m_height = 16;
			bullet.setHitbox(6, 6, 4, 4);
			bullet.m_FXurl = "FX/pistol_fire.mp3";
			return bullet;
		}
		
		public static function ElecBall():EnemyThrowable {
			var ball:EnemyThrowable = new EnemyThrowable(1, "Images/Enemies/ElectricSnake/elecBall.png", 2);
			ball.m_width = 24; ball.m_height = 24;
			ball.setHitbox(0, 9, 24, 24);
			ball.setAnimationAttack(true, 0, 1, 2);
			ball.m_fragile = false;
			//ball.m_FXurl = "FX/pistol_fire.mp3";
			return ball;
		}
		
		public static function Harpoon():EnemyThrowable {
			var har:EnemyThrowable = new EnemyThrowable(1, "Images/Weapons/harpoon.png");
			har.m_fourDirection = true;
			har.m_width = 32; har.m_height = 32;
			har.setHitbox(6, 6, 20, 20);
			return har;
		}
	}

}
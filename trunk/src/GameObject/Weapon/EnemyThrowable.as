package GameObject.Weapon 
{
	import GameObject.Enemy.Enemy;
	import GameObject.MovableObject;
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
		
		override public function setCaster(object:MovableObject) {
			super.setCaster(object);
			m_enemy = object as Enemy;
		}
		
		override public function CheckDamageDealt():Boolean {
			var result:Boolean = false;
			//check players for damage
			if (collide(Global.player1)){
				Global.player1.takeDamage(m_enemy, this);
				result = true;
			}
			if (collide(Global.player2)){
				Global.player2.takeDamage(m_enemy, this);
				result = true;
			}
			return result;
		}
		
		/////////////////////////////////////////////////////
		//////////////////PRBUILDED ENEMY THROWABLES/////////
		////////////////////////////////////////////////////
		public static function Slipper() : EnemyThrowable{
			return new EnemyThrowable(1, "Images/Weapons/slipper.png", 2);
		}
	}

}
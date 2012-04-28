package GameObject.Weapon 
{
	import GameObject.Enemy.Enemy;
	import GameObject.MovableObject;
	import GameObject.PlayableObject;
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerThrowable extends Throwable 
	{		
		public var m_player:PlayableObject;
		public var m_enemies:Vector.<Enemy>;
		
		public function PlayerThrowable(power:int,url:String,speed:int = 10) 
		{
			super(power, url, speed);
		}
		
		override public function setCaster(object:MovableObject) {
			super.setCaster(object);
			m_player = object as PlayableObject;
		}
		
		override public function CheckDamageDealt():Boolean {
			m_enemies = Global.currentState.m_enemies;
			var result:Boolean = false;
			//check enemies for damage
			for (var i:int = 0; i < m_enemies.length; i++) {
				var enemy:Enemy = m_enemies[i];
				if (enemy == null || enemy.isDead() )
					continue;
				//if collision with an enemy
				if (collide(enemy)) {
					result = true;
					//deal damage
					enemy.takeDamage(m_player , this);
					break;
				}
			}
			return result;
		}
		
		public static function Slipper() : PlayerThrowable{
			return new PlayerThrowable(1, "Images/Weapons/slipper.png", 10);
		}
	}

}
package GameObject.Weapon 
{
	import GameObject.Enemy.Enemy;
	import GameObject.Enemy.EnemySmoke;
	import GameObject.PlayableObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EggPlosion extends EnemySmoke 
	{
		private var m_player:PlayableObject;
		private var m_throwable:PlayerThrowable;
		
		public function EggPlosion() 
		{
			super();
			m_url = "Images/Enemies/explosion.png";
		}
		
		public function setCaster(player:PlayableObject, thr:PlayerThrowable):void {
			m_player = player;
			m_throwable = thr;
		}
				
		override public function playSmoke(X:Number, Y:Number ):void {
			super.playSmoke(X, Y);
			var enemies:Vector.<Enemy> = Global.currentPlaystate.m_enemies;
			//check enemies for damage
			for (var i:int = 0; i < enemies.length; i++) {
				var enemy:Enemy = enemies[i];
				if (enemy == null || enemy.isDead() || !enemy.m_stopBullets )
					continue;
				//if collision with an enemy
				if (collide(enemy)) {
					//deal damage
					enemy.takeDamage(m_player , m_throwable);
					break;
				}
			}
		}
	}

}
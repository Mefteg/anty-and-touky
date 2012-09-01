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
		public var m_explosion:EggPlosion;
		public var m_canExplode:Boolean = false;
		public var m_explosive:Boolean = false;
		
		public function PlayerThrowable(power:int, url:String, speed:int = 7) 
		{
			super(power, url, speed);
			m_width = 32;
			m_height = 32;
		}
		
		public function createExplosion():void {
			m_canExplode = true;
			m_explosion = new EggPlosion();			
		}
		
		override public function setCaster(object:MovableObject) : void {
			super.setCaster(object);
			m_player = object as PlayableObject;
			if (m_canExplode)
				m_explosion.setCaster(m_player, this);
		}
		
		override public function touched():void {
			if (m_explosive){
				m_explosion.playSmoke(x, y);
				m_explosive = false;
			}
			super.touched();
		}
		
		override public function CheckDamageDealt():Boolean {
			m_enemies = Global.currentPlaystate.m_enemies;
			var result:Boolean = false;
			//check enemies for damage
			for (var i:int = 0; i < m_enemies.length; i++) {
				var enemy:Enemy = m_enemies[i];
				if (enemy == null || enemy.isDead() || !enemy.m_stopBullets )
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
		
		public static function Egg():PlayerThrowable {
			var egg:PlayerThrowable = new PlayerThrowable(1, "Images/Weapons/egg.png");
			egg.setAnimationAttack(true,0, 1, 2, 3, 4, 5, 6, 7);
			egg.setAnimationDead(8, 9, 10, 11);
			egg.setHitbox(12, 13, 9, 11);
			egg.createExplosion();
			return egg;
		}
		
		public static function Ant():PlayerThrowable {
			var ant:PlayerThrowable = new PlayerThrowable(1, "Images/Weapons/ant.png");
			ant.setAnimationAttack(false);
			//ant.setAnimationDead(8, 9, 10, 11);
			ant.m_FXurl = "FX/pomp.mp3"
			ant.m_FX.volume = 1.0;
			ant.setHitbox(12, 13, 9, 11);
			return ant;
		}
		
		override public function addBitmap():void {
			super.addBitmap();
			if(m_canExplode)
				m_explosion.addBitmap();
		}
		
		override public function load():void {
			super.load();
			if (m_canExplode)
				m_explosion.load();
		}
	}

}
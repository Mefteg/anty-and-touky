package GameObject.Enemy.Centipede
{
	import GameObject.Enemy.Enemy;
	import GameObject.PlayableObject;
	import GameObject.Weapon.Weapon;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CentipedePart extends Enemy
	{
		private var m_boss:Centipede;
		public function CentipedePart(boss:Centipede)
		{
			super(0, 0);
			m_boss = boss;
			m_url = "Images/Enemies/centipedePart.png";
			m_stats.initHP(3);
			m_width = 32;
			m_height = 32;
		}
		
		override public function load():void
		{
			super.load();
			//walk anim
			addAnimation("walk" + RIGHT, [5, 6, 7], 15, true);
			addAnimation("walk" + LEFT, [1, 2, 3], 15, true);
			
			addAnimation("walkD" + RIGHT, [13, 14, 15], 15, true);
			addAnimation("walkD" + LEFT, [9, 10, 11], 15, true);
			play("walk" + RIGHT);
		}
		
		override public function update():void
		{
			commonEnemyUpdate();
		}
		
		override public function takeDamage(player:PlayableObject, weapon:Weapon):void
		{
			if (m_state == "walkD" || weapon.m_name == "Sword")
				return;
			//calculate damage
			var damage:int = weapon.m_power;
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			m_FXhit.play();
			//check death
			if (m_stats.m_hp_current <= 0)
			{
				m_state = "walkD";
				play(m_state + facing);
				m_boss.removePart();
			}
			//for twinkling
			changeTwinkleColor(_twinkleHit);
			beginTwinkle(3, 0.3);
		}
		override protected function takeRushDamage(player:PlayableObject):void {
			//calculate damage
			var damage:int = 5 ;
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			//check death
			if (m_stats.m_hp_current <= 0){
				m_state = "walkD";
				play(m_state + facing);
				m_boss.removePart();
			}
			//for twinkling
			changeTwinkleColor(_twinkleHit);
			beginTwinkle(3, 0.3);
		}
		
		public function changeDirection(face:uint):void {
			facing = face;
			play(m_state + facing);
		}
		
		override public function move():void
		{
			m_oldPos.x = this.x;
			m_oldPos.y = this.y;
			
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
		
		}
	}

}
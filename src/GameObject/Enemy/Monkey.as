package GameObject.Enemy 
{
	import GameObject.Weapon.EnemyThrowable;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class Monkey extends Enemy 
	{		
		public function Monkey(X:Number,Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Enemies/slime.png";
			m_width = 24;
			m_height = 24;
			createThrowables();
			m_state = "idle";
		}
		
		override protected function createThrowables():void {
			m_throwables = new Vector.<EnemyThrowable>;
			var thr:EnemyThrowable = EnemyThrowable.PistolBullet() ;
			thr.setCaster(this);
			m_throwables.push(thr);
			for (var i:int = 0; i < 15; i++) {
				thr = EnemyThrowable.PistolBullet();
				thr.setCaster(this);
				m_throwables.push(thr);
			}
		}	
		
		override public function load():void {
			super.load();
			loadThrowables();
			//IDLE ANIM
			addAnimation("idle" + UP, [0,1,2,1], 5, true);
			addAnimation("idle" + RIGHT, [0,1,2,1], 5, true);
			addAnimation("idle" + DOWN, [0,1,2,1], 5, true);
			addAnimation("idle" + LEFT, [0,1,2,1], 5, true);	
			//walk anim
			addAnimation("walk" + UP, [0,1,2,1], 3, true);
			addAnimation("walk" + RIGHT,[0,1,2,1], 3, true);
			addAnimation("walk" + DOWN, [0,1,2,1], 3, true);
			addAnimation("walk" + LEFT, [0,1,2,1], 3, true);
			//attack anim
			addAnimation("attack" + UP, [15,18,19,8,9], 3, false);
			addAnimation("attack" + LEFT, [5,6,7,8,9], 3, false);
			addAnimation("attack" + DOWN, [15,16,17,8,9], 3, false);
			addAnimation("attack" + RIGHT, [10,11,12,13,14], 3, false);
			//hit
			addAnimation("hit" + m_hit, [14], 1);
			addAnimation("dead", [20, 21, 22 , 23 ], 5, false);
			
			play("idle" + UP);
			
		}
		
		override public function attack():void {
			m_state = "attack";
			m_directionFacing = Utils.direction(new FlxPoint(x, y), new FlxPoint(m_target.x, m_target.y));
			var thr:EnemyThrowable = getThrowable();
			thr.place(x, y);
			thr.attack(facing);
		}
		
		override public function update():void {
			if (!onScreen()) return;
			checkPlayersDamage();
			twinkle();
			switch(m_state) {
				case "idle": if (m_timerAttack.finished) {
								attack();
								m_timerAttack.start(2);
							} break;
				case "attack": if (finished)
								m_state = "idle"; 
								break;
				case "dead": if (finished)
								removeFromStage();
							break;
			}
		}
		
	}

}
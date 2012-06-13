package GameObject.Enemy 
{
	import GameObject.Weapon.EnemyThrowable;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class Penguin extends Enemy 
	{
		protected var m_timerDraw:FlxTimer;
		
		public function Penguin(X:Number, Y:Number ) 
		{
			super(X, Y);
			m_url = "Images/Enemies/penguin_pistol.png";
			m_width = 32;
			m_height = 32;
			createThrowables();
			m_timerDraw = new FlxTimer();
			m_state = "idle";
		}
		
		override public function load():void {
			super.load();
			loadThrowables();
			//IDLE ANIM
			addAnimation("idle" + UP, [6], 5, false);
			addAnimation("idle" + RIGHT, [0], 5, false);
			addAnimation("idle" + DOWN, [9], 5, false);
			addAnimation("idle" + LEFT, [3], 5, false);	
			//walk anim
			addAnimation("draw" + UP, [7], 3, false);
			addAnimation("draw" + RIGHT,[1], 3, false);
			addAnimation("draw" + DOWN, [10], 3, false);
			addAnimation("draw" + LEFT, [4], 3, false);
			//attack anim
			addAnimation("attack" + UP, [8,8,7], 10, false);
			addAnimation("attack" + LEFT, [5,5,4], 10, false);
			addAnimation("attack" + DOWN, [11,11,10], 10, false);
			addAnimation("attack" + RIGHT, [2,2,1], 10, false);
			//hit
			addAnimation("hit" + m_hit, [14], 1);
			addAnimation("dead", [20, 21, 22 , 23 ], 5, false);
			
			play("idle" + UP);
		}
		
		override protected function createThrowables():void {
			m_throwables = new Vector.<EnemyThrowable>;
			var thr:EnemyThrowable;
			for (var i:int = 0; i < 4; i++) {
				thr = EnemyThrowable.PistolBullet();
				thr.setCaster(this);
				m_throwables.push(thr);
			}
		}
		
		override public function attack():void {
			m_state = "attack";
			m_directionFacing = Utils.direction(new FlxPoint(x, y), new FlxPoint(m_target.x, m_target.y));
			var thr:EnemyThrowable = getThrowable();
			thr.place(x, y);
			thr.attack(facing);
			play("attack" + facing);
		}
		
		override public function update():void {
			if ( !commonEnemyUpdate()) return;
			switch(m_state) {
				case "idle": 
							facing = getFacingToTarget(m_target);
							play("idle" + facing);
							if (m_timerAttack.finished) {
								m_state = "draw";
								play("draw" + facing);
								m_timerDraw.start(1);
							} break;
				case "draw": if (m_timerDraw.finished) {
								attack();
							} break;
				case "attack": if (finished){
									m_state = "idle"; 
									m_timerAttack.start(2);
								}
								break;
				case "dead": die();
							break;
			}
		}
		
	}

}
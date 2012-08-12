package GameObject.Enemy 
{
	import GameObject.Weapon.EnemyThrowable;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class FlyingCannon extends Enemy 
	{
		
		public function FlyingCannon(X:Number,Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Enemies/flyingCannon.png";
			m_width = 32; m_height = 32;
			m_collideEvtFree = true;
			m_collideWithObjects = false;
			createThrowables();
			m_stats.initHP(3);
			m_state = "offScreen";
		}
		
		public function prepareShot():void {
			m_state = "prepare";
			m_target = getRandomPlayer();
			facing = getFacingToTarget(m_target);
			play("prepare" + facing);
		}
		
		override public function attack():void {
			m_state = "idle";
			m_timerAttack.start(3);
			m_directionFacing = Utils.direction(new FlxPoint(x, y), new FlxPoint(m_target.x, m_target.y));
			var thr:EnemyThrowable = getThrowable();
			thr.place(x+m_throwPlaceArray[facing].x, y+m_throwPlaceArray[facing].y);
			thr.attack(facing);
			play("idle" + facing);
		}
		
		override public function update():void 
		{
			if (!commonEnemyUpdate())
				return;
			move()
			switch(m_state) {
				case "offScreen" : m_timerAttack.start(Utils.random(0.3, 1));
									m_direction = m_directionFacing;				
									m_state = "idle";
									break; 
				case "idle" : if (m_timerAttack.finished)
								prepareShot();
							break;
				case "prepare": if (finished)
									attack();
								break;
				case "dead" : die(); break;
				default : break;
			}
		}
		
		override public function load():void {
			super.load();
			
			addAnimation("idle" + LEFT, [0, 1, 2], 10, true);
			addAnimation("idle" + RIGHT, [6, 7, 8], 10, true);
			addAnimation("idle" + DOWN, [12,13,14], 10, true);
			addAnimation("idle" + UP, [18, 19, 20], 10, true);
			
			addAnimation("prepare" + LEFT, [3,4,5], 10, true);
			addAnimation("prepare" + RIGHT, [9,10,11], 10, true);
			addAnimation("prepare" + DOWN, [15,16,17], 10, true);
			addAnimation("prepare" + UP, [21,22,23], 10, true);
			
			play("idle" + LEFT);
			
		}
		
		override protected function createThrowables():void {
			m_throwables = new Vector.<EnemyThrowable>;
			var thr:EnemyThrowable;
			for (var i:int = 0; i < 3; i++) {
				thr = EnemyThrowable.CannonBullet();
				thr.setCaster(this);
				thr.m_collideEvtFree = true;
				m_throwables.push(thr);
			}
			commomThrowPlacement();
		}
		
	}

}
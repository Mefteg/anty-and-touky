package GameObject.Enemy 
{
	import GameObject.Other.Lift;
	import GameObject.PhysicalObject;
	import GameObject.Weapon.EnemyThrowable;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class Cannon extends Enemy 
	{
		private var m_straight:Boolean = true;
		private var m_lift:Lift;
		
		public function Cannon(X:Number,Y:Number,lift:String) 
		{
			super(X, Y);
			m_url = "Images/Enemies/cannon.png";
			m_height = 32; m_width = 32;
			m_smoke = EnemySmoke.Explosion();
			
			m_points = 200;
			m_state = "offScreen";
			if (lift != null){
				m_straight = false;
				switch(Global.difficulty) {
					case 1 : m_stats.initHP(2); break;
					case 2 : m_stats.initHP(3); break;
					case 3 : m_stats.initHP(3); break;
					default : m_stats.initHP(2); break;
				}
			}else {
				switch(Global.difficulty) {
					case 1 : m_stats.initHP(5); break;
					case 2 : m_stats.initHP(6); break;
					case 3 : m_stats.initHP(7); break;
					default : m_stats.initHP(2); break;
				}
			}
			createThrowables();
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
			if(m_straight)
				m_directionFacing = Utils.direction(new FlxPoint(x, y), new FlxPoint(m_target.x, m_target.y));
			else
				m_directionFacing = Utils.direction(new FlxPoint(x, y), new FlxPoint(m_lift.x , m_lift.y-m_lift.m_speed * Utils.random(80,100)));
			var thr:EnemyThrowable = getThrowable();
			thr.place(x+m_throwPlaceArray[facing].x, y+m_throwPlaceArray[facing].y);
			thr.attack(facing);
			play("idle" + facing);
		}
		
		override public function update():void 
		{
			if (!commonEnemyUpdate())
				return;
			switch(m_state) {
				case "offScreen" : m_timerAttack.start(0.2, 1);
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
		
		override public function addToStage():void {
			super.addToStage();
			Global.currentPlaystate.addPhysical(this as PhysicalObject);
			if (!m_straight)
				m_lift = Global.currentPlaystate.findObjectByType("Lift") as Lift;
		}
		
		override public function removeFromStage():void {
			super.removeFromStage();
			Global.currentPlaystate.removePhysical(this as PhysicalObject);
		}
		
		override public function load():void {
			super.load();
			
			addAnimation("idle" + RIGHT, [1], 0);
			addAnimation("idle" + LEFT, [0], 0);
			addAnimation("idle" + UP, [2], 0);
			addAnimation("idle" + DOWN, [3], 0);
			
			addAnimation("prepare" + RIGHT, [5,5], 5);
			addAnimation("prepare" + LEFT, [4,4], 5);
			addAnimation("prepare" + UP, [6,6], 5);
			addAnimation("prepare" + DOWN, [7,7], 5);
		}
		
		override protected function createThrowables():void {
			m_throwables = new Vector.<EnemyThrowable>;
			var thr:EnemyThrowable;
			for (var i:int = 0; i < 3; i++) {
				thr = EnemyThrowable.CannonBullet();
				thr.setCaster(this);
				thr.m_collideEvtFree = !m_straight;
				m_throwables.push(thr);
			}
			commomThrowPlacement();
		}
				
	}

}
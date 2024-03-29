package GameObject.Enemy 
{
	import GameObject.Weapon.EnemyThrowable;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class Penguin extends Enemy 
	{
		protected var m_timerDraw:FlxTimer;
		protected var m_sound:FlxSound;
		protected var m_playedSound:Boolean = true;
		protected var m_timerShout:FlxTimer;
		
		public function Penguin(X:Number, Y:Number ) 
		{
			super(X, Y);
			m_url = "Images/Enemies/penguin_pistol.png";
			m_sound = new FlxSound();
			m_sound.loadStream("FX/penguin.mp3");
			m_width = 32;
			m_height = 32;
			createThrowables();
			m_timerShout = new FlxTimer();
			m_timerDraw = new FlxTimer();
			m_state = "offScreen";
			switch(Global.difficulty) {
				case 1 : m_stats.initHP(2); break;
				case 2 : m_stats.initHP(3); break;
				case 3 : m_stats.initHP(4); break;
				default : break;
			}
		}
		
		override public function load():void {
			super.load();
			//IDLE ANIM
			addAnimation("idle" + UP, [9], 5, false);
			addAnimation("idle" + RIGHT, [0], 5, false);
			addAnimation("idle" + DOWN, [6], 5, false);
			addAnimation("idle" + LEFT, [3], 5, false);	
			//walk anim
			addAnimation("draw" + UP, [10], 3, false);
			addAnimation("draw" + RIGHT,[1], 3, false);
			addAnimation("draw" + DOWN, [7], 3, false);
			addAnimation("draw" + LEFT, [4], 3, false);
			//attack anim
			addAnimation("attack" + UP, [11,11,10], 10, false);
			addAnimation("attack" + LEFT, [5,5,4], 10, false);
			addAnimation("attack" + DOWN, [8,8,7], 10, false);
			addAnimation("attack" + RIGHT, [2,2,1], 10, false);
			//hit
			addAnimation("hit" + m_hit, [14], 1);
			addAnimation("dead", [20, 21, 22 , 23 ], 5, false);
			
			play("idle" + UP);
		}
		
		override protected function createThrowables():void {
			m_throwables = new Vector.<EnemyThrowable>;
			var thr:EnemyThrowable;
			for (var i:int = 0; i < 3; i++) {
				thr = EnemyThrowable.PistolBullet();
				thr.setCaster(this);
				m_throwables.push(thr);
			}
			commomThrowPlacement();
		}
		
		override public function attack():void {
			m_state = "attack";
			m_directionFacing = Utils.direction(new FlxPoint(x, y), new FlxPoint(m_target.x, m_target.y));
			var thr:EnemyThrowable = getThrowable();
			thr.place(x+m_throwPlaceArray[facing].x, y+m_throwPlaceArray[facing].y);
			thr.attack(facing);
			play("attack" + facing);
		}
		
		override public function update():void {
			if ( !commonEnemyUpdate()) return;
			switch(m_state) {
				case "offScreen" : m_timerAttack.start(Utils.random(1, 2));{
										m_state = "idle";
										//only some penguins will shout
										if ( Utils.random(0, 100) > 40 ) {
											// give a timer to avoid crowd
											m_timerShout.start( Utils.random(0, 1));
											m_playedSound = false;
										}
									}
									break;
				case "idle": playSound();
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
		
		public function playSound():void {
			if (m_playedSound)
				return;
			if (m_timerShout.finished) {
				m_sound.volume = Utils.random(0.5, 0.9);
				m_playedSound = true;
				m_sound.play();
			}
		}
		
		public static function Scientist(X:Number, Y:Number) {
			var scientist:Penguin = new Penguin(X, Y);
			scientist.m_url = "Images/Enemies/pinguin_scientist.png";
			switch(Global.difficulty){
				case 1 : scientist.m_stats.initHP(4);
				case 2 : scientist.m_stats.initHP(5);
				case 3 : scientist.m_stats.initHP(6);
				default : break;
			}
			return scientist;
		}
	}

}
package GameObject.Enemy.ElSqualo 
{
	import GameObject.Enemy.Enemy;
	import GameObject.Enemy.EnemySmoke;
	import GameObject.GameObject;
	import GameObject.PlayableObject;
	import GameObject.Weapon.Weapon;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SqualoRightArm extends Enemy 
	{
		protected var m_body:ElSqualo;
		
		protected var m_flames:Array;
		
		protected var NB_FLAMES:int = 10;
		protected var FLAME_OFFSET:int = 20;
		protected var m_currentFlame:int;
		
		protected var m_baseFlamePos:Array;
		
		protected var m_dirTab:Array = new Array(false, false);
		
		protected var m_timerSwing:FlxTimer;
		protected var m_dir:int;
		
		private var m_attackCount:int;
		private var m_attackMax:int;
		private var TIME_ATTACK:Number;
		
		protected var TIME_MIN:int;
		protected var TIME_MAX:int;
		
		private var m_haldDead:Boolean = false;
		private var m_over:Boolean = true;
		
		private var m_currentSmoke:int = 0;
		private var m_initY:Number;
		public var m_dead:Boolean = false;
		
		public function SqualoRightArm(body:ElSqualo) 
		{
			m_body = body;
			m_url = "Images/Enemies/ElSqualo/right_arm.png";
			m_width = 64; m_height = 64;
			m_activeOffscreen = true;
			createFlames();
			m_timerSwing = new FlxTimer();
			m_smoke = EnemySmoke.Explosion();
			switch(Global.difficulty) {
				case 1 : m_stats.initHP(65); break;
				case 2 : m_stats.initHP(100); break;
				case 3 : m_stats.initHP(130); break;
				default : break;
			}
			if (Global.nbPlayers > 1)
				m_stats.initHP(m_stats.m_hp_current * 1.5);
			m_speed = 1;
			x = m_body.x - 26; 
			y = m_body.y +16;
		}
		
		public function isOver():Boolean {
			 return m_over;
		}
		
		override public function update():void {
			if (!commonEnemyUpdate())
				return;
			switch(m_state) {
				case "waitForAttack": if (m_timerAttack.finished)
										attack();
										break;
				case "drawFlames": drawFlames(); break;
				case "swinging" : swingingFlames(); break;
				case "fall" : fall(); break;
				case "dying": dying(); break;
				default : break;
			}
			if(!m_dead){
				x = m_body.x - 26; 
				y = m_body.y +16;
			}
		}
		
		public function init(stage:int):void {
			m_attackCount = 0;
			switch(stage) {
				case 0 : m_attackMax = Utils.random(1, 2);
						TIME_MIN = 1;
						TIME_MAX = 2;
						break;
				case 1 : m_attackMax = Utils.random(1, 2);
						TIME_MIN = 1;
						TIME_MAX = 2;
						break;
				case 2 : m_attackMax = Utils.random(1, 2);
						TIME_MIN = 1;
						TIME_MAX = 1.5;
						break;
			}
			
			TIME_ATTACK = Utils.random(TIME_MIN, TIME_MAX);
			m_timerAttack.start(TIME_ATTACK);
			m_over = false;
			m_state = "waitForAttack";
		}
		
		override public function attack():void {
			frame = 1;
			m_state = "drawFlames";
			m_currentFlame = 0;
			m_flames[0].place(x+12, y+45);
			m_flames[0].addToStage();
		}
		
		private function createFlames():void {
			m_flames = new Array();
			var scale:Number = 0.5;
			var step:Number = (1 - scale) / NB_FLAMES;
			for (var i:int = 0; i < NB_FLAMES; i++){
				m_flames.push( new GameObject.Enemy.ElSqualo.SqualoFlame(i, this));
				m_flames[i].scale = new FlxPoint(scale, scale);
				scale += step;
			}
		}
		
		private function drawFlames():void {
			if (m_flames[m_currentFlame].m_state == "idle") {
				m_currentFlame++;
				if (m_currentFlame >= NB_FLAMES) {
					m_baseFlamePos = new Array();
					for (var i:int = 0; i < NB_FLAMES ; i++)
						m_baseFlamePos.push(new FlxPoint(m_flames[i].x, m_flames[i].y));
					swingFlames(-1);
					return;
				}
				m_flames[m_currentFlame].addToStage();
				m_flames[m_currentFlame].place(m_flames[m_currentFlame-1].x, m_flames[m_currentFlame-1].y);
				m_flames[m_currentFlame].moveTo(new FlxPoint(m_flames[m_currentFlame].x, m_flames[m_currentFlame].y + FLAME_OFFSET));
			}
		}
		
		private function swingFlames(dir:int) {
			m_state = "swinging";
			m_dir = dir;
			if (m_dir == -1)
				m_dirTab[0] = true;
			if (m_dir == 1)
				m_dirTab[1] = true;
			var off:int = 0;
			//if it goes to the right
			for (var i:int = 0; i < NB_FLAMES; i++) {
				m_flames[i].moveTo(new FlxPoint(m_baseFlamePos[i].x + off, m_baseFlamePos[i].y ));
				m_flames[i].m_speed = 2;
				off += m_dir * 10;
			}
		}
		
		private function swingingFlames():void {
			var done:Boolean = true;
			for (var i:int = 0; i < NB_FLAMES; i++)
				done = done && (m_flames[i].m_state == "idle") ;
			if (done) {
				if(m_dir == -1 || m_dir == 1){
					swingFlames(0);
				}else {
					if (m_dirTab[0] == false)
						swingFlames( -1);
					else if (m_dirTab[1] == false)
						swingFlames(1);
					else
						hideFlames();
				}
			}
		}
		
		private function hideFlames():void {
			frame = 0;
			m_dirTab[0] = false; m_dirTab[1] = false;
			for (var i:int = 0; i < NB_FLAMES; i++) {
				m_flames[i].removeFromStage();
			}
			m_attackCount++;
			if(m_attackCount>=m_attackMax){
				m_state = "idle";
				m_over = true;
			}else {
				TIME_ATTACK = Utils.random(TIME_MIN, TIME_MAX);
				m_timerAttack.start(TIME_ATTACK);
				m_state = "waitForAttack";
			}
		}
		
		///////////// OVERRIDES /////////////////
		override public function addBitmap():void {
			super.addBitmap();
			m_flames[0].addBitmap();
		}
		
		override public function load():void {
			super.load();
			for (var i:int = 0; i < m_flames.length; i++)
				m_flames[i].load();
		}
		
		override public function takeDamage(player:PlayableObject, weapon:Weapon):void {
			if (m_invincible || m_dead)
				return;
			//calculate damage
			var damage:int = weapon.m_power ;
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			if ( ! m_haldDead && m_stats.m_hp_current < m_stats.m_hp_max / 2 ) {
				m_haldDead = true;
				m_smoke.playSmoke(x, y);
				m_body.changeState(1);
			}
			m_FXhit.play();
			//check death
			if (m_stats.m_hp_current <= 0) {
				if(!Global.soloPlayer)
					m_killer = player;
				if (m_state == "drawFlames" || m_state == "swinging")
					hideFlames();
				m_state = "fall";
				m_initY = y;
				m_direction.y = 1;
				m_body.changeState(2);
				m_body.loseArm(false);
				m_timerDeath.start(1);
				m_dead = true;
			}
			//for twinkling
			changeTwinkleColor(_twinkleHit);
			beginTwinkle(3, 0.3);
		}
		
		protected function fall():void {
			move();
			if (y > m_initY + 20)
				die();
		}
		
		override public function die():void {
			m_state = "dying";
			m_smoke.playSmoke(x+10, y + 40);
		}
		
		private function dying():void {
			if (m_smoke.finished) {
				m_currentSmoke ++;
				if (m_currentSmoke < 5) {
					m_smoke.playSmoke(x + 10, y + 40 - m_currentSmoke * 10);
					alpha -= 0.1;
				}else {
					removeFromStage();
				}	
			}
		}
	
	}

}
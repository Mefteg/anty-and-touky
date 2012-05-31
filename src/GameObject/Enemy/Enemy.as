package GameObject.Enemy 
{
	import GameObject.IAObject;
	import GameObject.Magic.Magic;
	import GameObject.PlayableObject;
	import GameObject.Weapon.EnemyThrowable;
	import GameObject.Weapon.Weapon;
	import InfoObject.InfoDamage;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxTimer;
	import GameObject.Stats;
	/**
	 * ...
	 * @author ...
	 */
	public class Enemy extends IAObject 
	{
		public var m_anim:String;
		public var m_currentMagic:Magic;
		//TIMERS
		public var m_timerAttack:FlxTimer;
		public var m_timerHit:FlxTimer;
		public var m_timerDeath:FlxTimer;
		
		//TARGETTING
		public var m_target:PlayableObject;
		public var m_distanceToAttack:Number;
		public var m_hitboxNormal:Hitbox;
		public var m_hitboxAttack:Hitbox;
		//HIT VARIABLE
		public var m_timeHit:Number;
		public var m_hit:uint = 1;
		public var m_attackTime:Number = 2;
		
		private var m_smoke:EnemySmoke;
		
		private var m_FXhit:FlxSound;
				
		public var m_throwables:Vector.<EnemyThrowable>;
		
		public function Enemy(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_speed = 2;
			m_timeHit = 1;
			m_distanceToAttack = m_width;
			m_state = "lookfor";
			m_timerTwinkle.start(0.1);
			m_stats = new Stats();
			m_stats.initHP(4);
			m_timerHit = new FlxTimer();
			m_timerHit.start(0.1);
			m_timerAttack = new FlxTimer();
			m_timerAttack.start(1);
			m_timerDeath = new FlxTimer();
			m_target = getRandomPlayer();
			m_smoke = new EnemySmoke();
			m_FXhit = new FlxSound();
			m_typeName = "Enemy";
			m_bufferGroup = DepthBufferPlaystate.s_enemyGroup;
		}
		
		override public function load():void {
			super.load();
			m_smoke.load();
			m_FXhit.loadStream("FX/hit.mp3");
		}
							
		override public function removeFromStage():void {
			super.removeFromStage();
			if (!m_throwables)
				return;
			for (var i:int = 0; i < m_throwables.length ; i ++)
				m_throwables[i].removeFromStage();
		}
		
		protected function createThrowables():void {}
		
		public function getThrowable():EnemyThrowable {
			var thr:EnemyThrowable;
			for (var i:int = 0; i < m_throwables.length; i++) {
				if (m_throwables[i].isFree()) {
					thr = m_throwables[i];
					break;
				}
			}
			return thr;
		}
		
		public function loadThrowables() : void {
			if (!m_throwables)
				return;
			for (var i:int = 0; i < m_throwables.length; i++) {
				m_throwables[i].load();
			}
		}
		
		override public function addBitmap():void {
			super.addBitmap();
			if (!m_throwables)
				return;
			m_throwables[0].addBitmap();
			m_smoke.addBitmap();
		}
						
		public function giveDamage():void {
			if (collide(Global.player1))
				Global.player1.takeDamage();
			if (collide(Global.player2))
				Global.player2.takeDamage();
		}
	
		
		///////////////////////////////////////////////////////
		///////////////TAKE DAMAGE/////////////////////////////
		///////////////////////////////////////////////////////
		
		public function takeDamage(player:PlayableObject, weapon:Weapon):void {
			//calculate damage
			var damage:int = weapon.m_power ;
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			m_FXhit.play();
			//check death
			if (m_stats.m_hp_current < 0){
				m_state = "dead";
				m_timerDeath.start(1);
				play("dead");
			}
			//for twinkling
			changeTwinkleColor(_twinkleHit);
			beginTwinkle(3, 0.3);
		}
		
		public function takeMagicDamage(player:PlayableObject, magic:Magic):void {
			//start timer during when the enemy is hit
			m_timerHit.start(m_timeHit);
			m_state = "hit";
			//calculate damage
			var damage:int = magic.m_power + player.m_stats.m_magic_attack_current ;
			damage = damage * Utils.random(0.9, 1.1) - m_stats.m_magic_defense_current;
			damage *= m_stats.m_elementalDefense.getDefenseRatio(magic.m_elemental);
			//display damage
			var info:InfoDamage = new InfoDamage(x, y, String(damage));
			info.addToStage();
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			//check death
			if (m_stats.m_hp_current < 0) {
				m_state = "dead";
				m_timerDeath.start(1);
			}
		}
		
		override public function update() : void {
			checkPlayersDamage();
			twinkle();
			if (m_blocked) return;
												
			switch ( m_state ) {
				case "idle":
					m_anim = "idle";
					break;
				case "walk":
					m_anim = "walk";
					move();
					break;
				case "lookfor":
					m_anim = "walk";
					lookfor();
					break;
				case "dead": if (m_timerDeath.finished)
									removeFromStage();
							break;
				case "attack":
					attack();
					break;
				default:
					break;
			}

			
			//plays the animation	
			play(m_anim + facing);
		}

		
		override public function move() : void {
			m_oldPos.x= this.x;
			m_oldPos.y = this.y;
			
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
			
			if ( this.interactWithEnv() ) {
				this.x = m_oldPos.x;
			}
			if ( this.interactWithEnv() ) {
				this.y = m_oldPos.y;
			}
			else {
				m_state = "lookfor";
			}
			
			if (m_direction.x < 0) facing = LEFT;
			else if (m_direction.x > 0) facing = RIGHT;
			else if (m_direction.y < 0) facing = UP;
			else if (m_direction.y > 0) facing = DOWN;
			
			m_state = "lookfor";
		}
		
		public function attack() : void {
			
		}
		
		public function lookfor() : void {
			
			m_target= getNearestPlayer();
			goTo(m_target);
			//check if an attack is available
			if (Utils.distance(getCenter(), m_target.getCenter()) < m_distanceToAttack) {
				m_state = "attack";
			}else{
				m_state = "walk";
			}
		}
		
		public function getRandomPlayer():PlayableObject {
			var r:Number = Utils.random(0, 2);
			if (r < 1)
				return Global.player1;
			else
				return Global.player2;
		}
		
		public function isDead():Boolean {
			return m_state == "dead";
		}
		
		protected function takeRushDamage():void {
			//calculate damage
			var damage:int = 5 ;
			//display damage
			var info:InfoDamage = new InfoDamage(x, y, String(damage));
			info.addToStage();
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			//check death
			if (m_stats.m_hp_current < 0)
				m_state = "dead";
				m_timerDeath.start(1);
			//for twinkling
			changeTwinkleColor(_twinkleHit);
			beginTwinkle(3, 0.3);
		}
		
		protected function checkPlayersDamage():void {
			if (collide(Global.player1)) {
				if (Global.player1.isRushing()) {
					Global.player1.unspecial();
					takeRushDamage();
				}else{
					Global.player1.takeDamage();
				}
			}
			
			if (collide(Global.player2)) {
				if (Global.player2.isRushing()) {
					Global.player1.unspecial();
					takeRushDamage();
				}else{
					Global.player2.takeDamage();
				}
			}
		}		
		
		public function die():void {
			m_state = "anihilated";
			removeFromStage();
			m_smoke.playSmoke(x, y);
		}
	}

}
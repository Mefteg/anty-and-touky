package GameObject.Enemy 
{
	import GameObject.IAObject;
	import GameObject.Item.Collectable;
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
		
		public var m_activeOffscreen:Boolean = false;
		
		protected var m_smoke:EnemySmoke;
		
		protected var m_FXhit:FlxSound;
				
		public var m_throwables:Vector.<EnemyThrowable>;
		
		public var m_dropRatio:Number = 7;

		protected var m_points:int = 100;
		protected var m_killer:PlayableObject;
		
		protected var m_invincible:Boolean = false;
		
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
			if (Global.soloPlayer)
				m_killer = Global.player1;
			m_bufferGroup = DepthBufferPlaystate.s_enemyGroup;
		}
		
		override public function load():void {
			super.load();
			m_smoke.load();
			loadThrowables();
			m_FXhit.loadStream("FX/hit.mp3");
		}
							
		override public function removeFromStage():void {
			super.removeFromStage();
			if (!m_throwables)
				return;
			for (var i:int = 0; i < m_throwables.length ; i ++)
				if(! m_throwables[i].isAttacking())
					m_throwables[i].removeFromStage();
		}
		
		protected function createThrowables():void {
			m_throwables = new Vector.<EnemyThrowable>;
			var thr:EnemyThrowable;
			for (var i:int = 0; i < 3; i++) {
				thr = EnemyThrowable.PistolBullet();
				thr.setCaster(this);
				m_throwables.push(thr);
			}
		}
		
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
			m_smoke.addBitmap();
			if (!m_throwables)
				return;
			m_throwables[0].addBitmap();
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
			if (m_invincible)
				return;
			//calculate damage
			var damage:int = weapon.m_power ;
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			m_FXhit.play();
			//check death
			if (m_stats.m_hp_current <= 0) {
				if(!Global.soloPlayer)
					m_killer = player;
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
			if (!commonEnemyUpdate())
				return;
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
			
			if(!m_collideEvtFree){
				if ( this.collideWithEnv() ) {
					this.x = m_oldPos.x;
				}
				if ( this.collideWithEnv() ) {
					this.y = m_oldPos.y;
				}
			}
			
			if (m_direction.x < 0) facing = LEFT;
			else if (m_direction.x > 0) facing = RIGHT;
			else if (m_direction.y < 0) facing = UP;
			else if (m_direction.y > 0) facing = DOWN;
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
			if (Global.soloPlayer)
				return Global.soloPlayer;
				
			var r:Number = Utils.random(0, 100);
			if (r < 50)
				return Global.player1;
			else
				return Global.player2;
		}
		
		public function isDead():Boolean {
			return m_state == "dead";
		}
		
		protected function takeRushDamage(player:PlayableObject):void {
			if (m_invincible)
				return;
			//calculate damage
			var damage:int = 5 ;
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			//check death
			if (m_stats.m_hp_current < 0){
				m_state = "dead";
				m_timerDeath.start(1);
				if(!Global.soloPlayer)
					m_killer = player;
			}
			//for twinkling
			changeTwinkleColor(_twinkleHit);
			beginTwinkle(3, 0.3);
		}
		
		protected function checkPlayersDamage():void {
			if (Global.nbPlayers == 1) {
				checkPlayerDamage(Global.soloPlayer);
			}else {
				checkPlayerDamage(Global.player1);
				checkPlayerDamage(Global.player2);
			}
		}		
		
		protected function checkPlayerDamage(player:PlayableObject):void {
			if (collide(player)) {
				if (player.isRushing()) {
					player.unspecial();
					player.x = player.m_oldPos.x;
					player.y = player.m_oldPos.y;
					takeRushDamage(player);
				}else{
					player.takeDamage();
				}
			}
		}
		
		public function die():void {
			m_state = "anihilated";
			removeFromStage();
			m_smoke.playSmoke(x, y);
			dropItem();
			m_killer.addScore(m_points);
		}
		
		protected function commonEnemyUpdate():Boolean {
			if (Global.frozen || ( !m_activeOffscreen && !onScreen() ) ) return false;
			checkPlayersDamage();
			twinkle();
			return true;
		}
		
		protected function dropItem():void {
			var rand:Number = Utils.random(0, 100);
			if (rand > m_dropRatio)
				return;
			var item:Collectable = Collectable.HeartDrop();
			item.place(x, y);
			item.addToStage();
		}
	}

}
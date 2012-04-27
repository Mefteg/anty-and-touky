package GameObject.Magic 
{
	import flash.errors.StackOverflowError;
	import GameObject.DrawableObject;
	import GameObject.Enemy.BlackSquare;
	import GameObject.Enemy.Enemy;
	import GameObject.MovableObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxSound;
	import org.flixel.FlxTileblock;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author Moi
	 */
	public class Magic extends MovableObject
	{
		public var m_elemental:Elemental;
		//power of the magic
		public var m_power:int;
		//mana consumption for this magic
		public var m_manaCons:int = 4;
		//time to cast the magic
		public var m_castingTime:Number;
		public var m_timeAction:Number=0;
		public var m_timeHit:Number = 1;
		//timers
		protected var m_timerAction:FlxTimer;
		protected var m_timerHit:FlxTimer;
		//variables for sound
		public var m_FXurl:String;
		public var m_FX:FlxSound;
		public var m_FXloop:Boolean;
		//shots
		protected var m_shotsCount:int = 0;
		public var m_shotsMax:int = 1;
		
		public var m_caster:DrawableObject;
		public var m_player:PlayableObject;
		public var m_enemy:Enemy;
		protected var m_linked:Boolean=false;
		protected var m_isPlayerCaster:Boolean = true;
		protected var m_enemies:Vector.<Enemy>;
		public var m_iconImage:String;
		//shift distance when cast
		public var m_distancePop:Number  = 10;
		
		public function Magic( power:int, url:String = "", width:int = 24, height:int = 32) 
		{
			super(0,0);
			m_url = url;
			m_power = power;
			m_width = width;
			m_height = height;
			m_timeAction = 1;
			m_iconImage = "Images/Menu/icon_rod_basic.png";
			m_FX = new FlxSound();
			m_timerAction = new FlxTimer();
			m_timerHit = new FlxTimer();
			m_elemental = new Elemental();
			m_typeName = "Magic";
		}
		
		public function setElemental(...rest):void {
			m_elemental.setStats(rest);
		}
		
		public function setTimes(castingTime:Number,hitTime:Number, actionTime:Number) {
			m_castingTime = castingTime; m_timeHit = hitTime; m_timeAction = actionTime;
			if (actionTime == 0)
				m_timeAction = 0.00001;
		}
		
		public function setCasterPlayer(object:PlayableObject):void {
			m_caster = object;
			m_player = object as PlayableObject;
			m_isPlayerCaster = true;
		}
		public function setCasterEnemy(object:Enemy):void {
			m_caster = object;
			m_enemy = object as Enemy;
			m_isPlayerCaster = false;
		}
		
		//for magics that disappear on contact
		public function touched():void {
			removeFromStage();
			m_FX.stop();
			m_state = "idle";
			m_direction.x = 0;
			m_direction.y = 0;
			x = 0; y = 0;
			if(m_linked)
				FreeCaster();
		}
		
		public function isAttacking():Boolean {
			return m_state == "attack";
		}
		
		override public function addBitmap():void {
			Global.library.addUniqueBitmap(m_url);
			if(m_iconImage)
				Global.library.addUniqueBitmap(m_iconImage);
		}
		override public function addToStage():void {
			Global.currentState.depthBuffer.addNonPhysicalPlayer(this);
		}
		
		override public function removeFromStage():void {
			Global.currentState.depthBuffer.removeNonPhysicalPlayer(this);
		}
		
		public function addToMenu():void {
			if (!m_isPlayerCaster)
				return;
			if (m_caster.toString() == "Player1")
				Global.buttonMenuMagicPlayer1.addMagic(m_player.m_magics.length - 1);
			else
				Global.buttonMenuMagicPlayer2.addMagic(m_player.m_magics.length - 1);
		}
		public function attack():void {
			if (m_state != "idle")
				return;
			x = m_caster.x; y = m_caster.y;
			switch(m_caster.facing) {
				case RIGHT : this.x += (m_caster.m_width+m_distancePop-m_hitbox.getCenter().x); this.y -= m_hitbox.getCenter().y - m_caster.m_hitbox.getCenter().y; break;
				case LEFT : this.x -= (m_distancePop + m_hitbox.getCenter().x); this.y -= m_hitbox.getCenter().y - m_caster.m_hitbox.getCenter().y; break;
				case UP : this.x -= m_hitbox.getCenter().x - m_caster.m_hitbox.getCenter().x; this.y -= m_distancePop + m_hitbox.getCenter().y + m_caster.m_height; break;
				case DOWN : this.x -= m_hitbox.getCenter().x - m_caster.m_hitbox.getCenter().x; this.y += m_distancePop + m_caster.m_height; break;
			}
			addToStage();
			m_FX.play();
			m_state = "attack";
			play("attack")
			m_timerAction.start(m_timeAction);
			m_timerHit.finished = true;
			m_linked = true;
		}
		public function setAnimationAttack(...rest):void {
			addAnimation("attack", rest, 8, true);
		}
		public function setFXAction(url:String, loop:Boolean = false ) {
			m_FXurl = url;
			m_FXloop = loop;
		}
		override public function load():void {
			super.load();			
			//sound
			m_FX.loadStream(m_FXurl,m_FXloop);
		}
		
		override public function update():void {
			super.update();
			if (m_state == "attack") {
				if (m_timerAction.finished){
					touched();
					m_caster.m_state = "idle";
					return;
				}
				//check if the magic can deal damage
				if (m_timerHit.finished) {
					//check damage
					if (CheckDamageDealt()) {
						m_shotsCount++;
						if (m_shotsCount >= m_shotsMax) {
							touched();
						}else {
							m_timerHit.start(m_timeHit);
						}
					}
				}
			}
		}
		
		public function CheckDamageDealt():Boolean {
			var result:Boolean = false;
			if(m_isPlayerCaster)
				m_enemies = Global.currentState.m_enemies;
			if (m_isPlayerCaster) {
				//check enemies for damage
				for (var i:int = 0; i < m_enemies.length; i++) {
					var enemy:Enemy = m_enemies[i];
					if (enemy == null || enemy.isDead() )
						continue;
					//if collision with an enemy
					if (collide(enemy)) {
						result = true;
						//deal damage
						enemy.takeMagicDamage(m_player , this);
					}
				}
			}else {
				//check players for damage
				if (collide(Global.player1)){
					Global.player1.takeMagicDamage(m_enemy, this);
					result = true;
				}
				if (collide(Global.player2)){
					Global.player2.takeMagicDamage(m_enemy, this);
					result = true;
				}
			}
			return result;
		}
		
		protected function FreeCaster():void {
			if(m_isPlayerCaster){
				m_player.m_state = "idle";
				m_player.m_currentMagic = null;
			}else {
				m_enemy.m_state = "idle";
				m_enemy.m_currentMagic = null;
			}
			m_linked = false;
		}
		//////////////////////////////////////////////////
		////////////PREBUILDED MAGICS////////////////////
		/////////////////////////////////////////////////
		
		public static function Tornado():Magic {
			var tornado:Magic = new Magic(2, "Images/Magics/tornado.png", 96, 96);
			tornado.m_iconImage = "Images/Menu/icon_magic_tornado.png";
			tornado.setFXAction("FX/swipe.mp3", true);
			tornado.setAnimationAttack(0, 1, 2);
			tornado.setTimes(1, 0.3, 3);
			tornado.m_shotsMax = 12;
			tornado.m_distancePop = 20;
			tornado.setElemental("wind", "thunder");
			return tornado;
		}
		
		public static function Fireball():MovableMagic {
			var fireball:MovableMagic = new MovableMagic(15, "Images/Magics/fireball.png", 48, 48);
			fireball.m_iconImage = "Images/Menu/icon_magic_fireball.png";
			fireball.setFXAction("FX/swipe.mp3");
			fireball.setAnimationAttack(3, 4, 5);
			fireball.setTimes(1, 1, 0);
			fireball.setElemental("fire");
			fireball.m_shotsMax = 2;
			fireball.m_distancePop = 1;
			return fireball;
		}
	}

}
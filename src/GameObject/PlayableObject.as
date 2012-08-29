package GameObject 
{
	import GameObject.Armor.Armor;
	import GameObject.Enemy.Enemy;
	import GameObject.Enemy.EnemySmoke;
	import GameObject.Equipement;
	import GameObject.Item.Item;
	import GameObject.Item.ItemManager;
	import GameObject.Magic.Magic;
	import GameObject.Magic.MovableMagic;
	import GameObject.Menu.Camembert;
	import GameObject.Menu.Menu;
	import GameObject.Weapon.PlayerThrowable;
	import GameObject.Weapon.Sword;
	import GameObject.Weapon.Throwable;
	import GameObject.Weapon.Weapon;
	import InfoObject.InfoDamage;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSave;
	import org.flixel.FlxSound;
	import org.flixel.FlxText;
	import org.flixel.FlxTileblock;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author Tom
	 */
	public class PlayableObject extends PhysicalObject 
	{	
		public var m_menu:GameObject.Menu.Menu;
		public var m_camembert:GameObject.Menu.Camembert;
		public var m_equipement:Equipement;
		
		public var m_throwables:Vector.<PlayerThrowable>;
		
		public var m_magics:Vector.<Magic>;
		public var m_currentMagic:GameObject.Magic.Magic = null;
		
		public var m_itemManager:GameObject.Item.ItemManager;
		
		public var m_timerDefense:FlxTimer;
		public var m_timerMagicCast:FlxTimer;
		public var m_timerAttack2:FlxTimer;
		
		public var m_timerSpecial:FlxTimer;
		protected var m_timerSpecialAvailable:FlxTimer;
		
		//keys
		public var m_stringValidate:String;
		public var m_stringPrevious:String;
		public var m_stringNext:String;
		
		public var m_scrollBlockUp:Boolean = false;
		public var m_scrollBlockDown:Boolean = false;
		public var m_scrollBlockRight:Boolean = false;
		public var m_scrollBlockLeft:Boolean = false;
		
		//SOUNDS
		public var FX_shieldClang:FlxSound;
		public var FX_drawWeapon:FlxSound;
		public var FX_hit:FlxSound;
		
		public var m_enemies:Vector.<GameObject.Enemy.Enemy>;
		
		public var m_onSpecial:Boolean = false;	
		
		public var m_lifes:int = 3;
		public var m_initHealth:int = 5;
		protected var m_smoke:EnemySmoke;
		
		public var m_score:int = 0;
		public var m_thresoldScore:int = 0;
		public var m_thresoldDelta:int = 5000;
		
		//SuperShots
		public var m_superShot:Boolean = false;
		public var m_superShotCount:int;
		private var SHOT_COUNT_MAX:int = 15;
				
		public function PlayableObject(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_thresoldScore += m_thresoldDelta;
			m_speed = 1.9;
			m_typeName = "Player";
			m_url = "Images/Players/anty.png";
			m_width = 48;
			m_height = 48;
			m_state = "idle";
			_twinkleHit = 0xFFFFFF;
			m_equipement = new GameObject.Equipement;
			m_magics = new Vector.<Magic>;
			m_stats = new GameObject.Stats();
			m_stats.initHP(m_initHealth);
			m_timerSpecial = new FlxTimer();
			m_timerSpecialAvailable = new FlxTimer();
			m_timerSpecialAvailable.start(0.1);
			m_timerDefense = new FlxTimer();
			m_timerMagicCast = new FlxTimer();
			m_timerAttack2 = new FlxTimer();
			m_timerTwinkle.start(0.1);
			m_smoke = EnemySmoke.PlayerSmoke();
			//SOUNDS
			FX_shieldClang = new FlxSound();
			FX_drawWeapon = new FlxSound();
			FX_hit = new FlxSound();
			m_magics.push(Magic.Tornado());
			m_magics.push(Magic.Fireball());
			m_itemManager = new GameObject.Item.ItemManager(this);
			getWeapon().m_player = this;
			createThrowables();
		}
		
		public function createThrowables() :void {}
		
		public function loadThrowables() : void {	
			for (var i:int = 0; i < m_throwables.length; i++) {
				m_throwables[i].load();
			}
		}
				
		public function getEnemiesInScene():void {
			m_enemies = Global.currentPlaystate.m_enemies;
		}
		/**
		 * Add Bitmaps of all the elements of the object
		 */
		override public function addBitmap():void {
			super.addBitmap();
			/*for (var i:int = 0; i < m_magics.length; i++){
				m_magics[i].addBitmap();
				m_magics[i].setCasterPlayer(this);
			}*/
			m_equipement.addToLibrary();
			//m_itemManager.addToLibrary();
			m_smoke.addBitmap();
			m_camembert.addBitmap();
			m_throwables[0].addBitmap();
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_playerGroup);
			//add the equipement
			m_equipement.addToStage();
			m_camembert.addToStage();
		}
		
		override public function load():void {
			super.load();
			m_equipement.load();
			m_camembert.load();
			m_smoke.load();
			//sounds
			FX_shieldClang.loadStream("FX/clang.mp3");
			FX_drawWeapon.loadStream("FX/swordDrawn.mp3");
			FX_hit.loadStream("FX/hit.mp3");
			//magic
			/*for (var i:int = 0; i < m_magics.length; i++){
				m_magics[i].load();
			}
			m_itemManager.load();*/
			loadThrowables();
		}
		
		override public function isBusy():Boolean {
			return isAttacking() || (m_state == "attack2") || (m_state == "defense") || (m_state == "magic") || (m_state == "item") || (m_state == "respawn") || (m_state == "waitToukyPosition");
		}
		
		public function isAttacking():Boolean {
			return (m_state == "attack") || (m_state == "attack2") || (m_state == "waitForAttack2" && finished) ;
		}
		
		public function isRushing():Boolean {
			return m_state == "rushAttack";
		}
		
		public function attack():void {
			if (isBusy() && !m_state=="waitForAttack2")
				return;
			//if it the second attack
			if (m_state == "waitForAttack2") {
				getWeapon().attack2(facing);
				play("attack2" + facing);
				m_state = "attack2";
			}else {
				getWeapon().attack(facing);
				play("attack" + facing);
				m_state = "attack";
			}
			//place weapon
			switch(facing) {
				case UP : getWeapon().place(x+12,y-5); break;
				case DOWN :getWeapon().place(x+12,y+35); break;
				case RIGHT :getWeapon().place(x+45, y+15); break;
				case LEFT :getWeapon().place( x-24,y+15); break;
			}
		}
		
		public function throwIt():void {
			if (m_state == "throw")
				return;
			m_state = "throw";
			play("throw" + facing, true);
		}
		
		public function throwBullet():void{}
		
		public function triggerSpecial():void {
			
		}
		
		public function unspecial():void {
			
		}
		
		public function resetSpecial():void {
			unspecial();
			play("idle" + facing);
			m_timerSpecialAvailable.start(0.01);
			m_camembert.resetTime();
			resetTwinkle();
		}
		
		public function magicAttack(i:int):void {
			/*if (i >= m_magics.length || isBusy())
				return;
			m_currentMagic = m_magics[i];
			m_timerMagicCast.start(m_currentMagic.m_castingTime);
			m_state = "magic";
			play(m_state + facing);*/
		}
		
		public function useItem() :void {
			m_state = "item";
			play("item");
		}
		
		override public function update():void {
			if (Global.frozen)
				return;
			if ( ! this.isToUpdate() )
				return;
			twinkle();
			if (m_onSpecial) {
				if (m_timerSpecial.finished)
					unspecial();
				else
					placeOtherPlayer();
			}
			switch(m_state) {
				case "attack": if (finished) {
									m_state = "waitForAttack2"; 
									m_timerAttack2.start(0.5); 
								}
								break;
				case "waitForAttack2": if (m_timerAttack2.finished) { 
											m_state = "idle"; 
											getWeapon().Idleize(); 
										} break;
				case "attack2" : if (finished) { m_state = "idle"; getWeapon().Idleize();} break;
				case "idle":  break;
				case "throw": if (finished){
									throwBullet();
								}
								break;
				case "walk":  break;
				case "defense": if (m_timerDefense.finished) m_state = "idle"; break;
				case "magic": 	if (m_timerMagicCast.finished && ( (m_currentMagic) && (m_currentMagic.m_state != "attack"))) {
									m_stats.m_mp_current -= m_currentMagic.m_manaCons;
									m_currentMagic.attack();
								}
								break;
				case "item": if (finished) m_state = "idle"; break;
				case "rushAttack" : rushAttack(); break;
				case "respawn" : respawning(); break;
				default : break;
			}
			//to move the player
			getMoves();
		}
		
		public function triggerRushAttack(facing:uint ):void { }
		public function rushAttack():void { }
		
		public function getMoves():void { }
		
		override public function move():void {
			m_canGoThrough = true;
			if (isBusy() || isAttacking())
				return;
			//it's useless to detect a collision if an object is not moving at all
			/*if (m_canGoThrough || (m_direction.x == 0 && m_direction.y == 0))
				return;*/
			
			//move 
			m_oldPos.x = x; m_oldPos.y = y;
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
			
			// if the new position involves an environment collision
			if ( !m_collideEvtFree && this.collideWithEnv() ) {
				if (m_state == "rushAttack")
					Global.player1.unspecial();
					
				var newPos:FlxPoint = new FlxPoint(this.x, this.y);
				
				this.y = m_oldPos.y;
				// if the collision is on the x axis
				if ( this.collideWithEnv() ) {
					this.x = m_oldPos.x;
				}
				
				this.y = newPos.y;
				// if the collision is also on the y axis
				if ( this.collideWithEnv() ) {
					this.y = m_oldPos.y;
				}
			}
		}
		
		public function takeDamage():Boolean {
			if (Global.soloPlayer && Global.soloPlayer.m_name != m_name)
				return false;
			if (!m_timerTwinkle.finished || isRushing() || m_state == "respawn")
				return false;
			FX_hit.play();
			//start timer during when the enemy is hit
			changeTwinkleColor(_twinkleHit);
			beginTwinkle(20, 1.5);
			m_stats.m_hp_current --;
			//if no more health
			if (m_stats.m_hp_current == 0 ){
				if(m_lifes > 0){ 
					respawn();
				}else{
					die();
					return false;
				}
			}
			return true;
		}
		
		public function takeMagicDamage(enemy:Enemy, magic:Magic):void {
			//start timer during when the enemy is hit
			//m_timerHit.start(m_timeHit);
			m_state = "hit";
			//calculate damage
			var damage:int = magic.m_power + enemy.m_stats.m_magic_attack_current ;
			damage = damage * Utils.random(0.9, 1.1) - m_stats.m_magic_defense_current;
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			//check death
			/*if (m_stats.m_hp_current < 0)
				removeFromStage();*/
		}
				
		/**
		 * Adds a new magic to the player magics list and dynamically load it
		 * @param	magic
		 */
		public function addMagic(magic:Magic) : void{
			m_magics.push(magic);
			magic.m_caster = this;
			magic.addBitmap();
			magic.setCasterPlayer(this);
			Global.currentPlaystate.loadNewBitmaps(magic);
		}
		
		override public function respawn() : void {
			visible = false;
			unspecial();
			m_timerMagicCast.start(4);
			m_lifes --;
			m_state = "respawn";
			m_smoke.playSmoke(x, y);
		}
		
		public function respawning():void {
			if (m_timerMagicCast.finished) {
				visible = true;
				m_state = "idle";
				m_stats.initHP(m_initHealth);
				m_menu.reInitHearts();
				changeTwinkleColor(_twinkleHit);
				beginTwinkle(20, 3);
			}
		}
		
		public function die():void {
			visible = false;
			m_smoke.playSmoke(x, y);
			Global.currentPlaystate.end();
		}
		
		public function addSuperShots():void {
			m_superShot = true;
			m_superShotCount += SHOT_COUNT_MAX;
		}
		
		public function addEnergy(energy:int):void {
			if (m_stats.m_hp_current + energy > m_initHealth ) {
				m_stats.initHP(m_initHealth);
				m_menu.reInitHearts();
			}else {
				m_stats.m_hp_current += energy;
				m_menu.addHearts(energy);
			}
		}
		
		public function addSpecial(spec:int):void {
			if (m_onSpecial) {
				var time:Number = m_timerSpecial.time;
				var timeLeft:Number = m_timerSpecial.timeLeft;
				m_timerSpecial = new FlxTimer();
				//si on va ajouter trop de temps
				if (time - timeLeft < spec) {
					//relancer un timer entier
					m_timerSpecial.start(time);
					m_camembert.trigger(time, true);
				}else { //sinon
					//relancer un timer avec le temps ajouté
					m_timerSpecial.start(timeLeft + spec);
					m_camembert.removeTime(spec);			
				}
			}else {
				if (m_timerSpecialAvailable.finished)
					return;
				var time:Number = m_timerSpecialAvailable.time;
				var timeLeft:Number = m_timerSpecialAvailable.timeLeft;
				m_timerSpecialAvailable = new FlxTimer();
				//si on va enlever trop de temps
				if ( timeLeft - spec < 0) {
					//stopper le timer
					m_camembert.resetTime();
				}else { //sinon
					//relancer un timer avec le temps ajouté
					m_timerSpecialAvailable.start(timeLeft - spec);
					m_camembert.addTime(spec);			
				}
			}
		}
		
		public function addScore(n:int):void {
			m_score += n;
			if (m_score >= m_thresoldScore) {
				m_thresoldScore += m_thresoldDelta;
				m_lifes++;
			}
		}
		/**
		 * Adds a new item to the player ItemManager
		 * @return
		 */
		public function addItem(item:String,qty:int) : void {
			m_itemManager.addItem(item, qty);
		}
		
		public function placeOtherPlayer():void { }
		public function placeThrowable(thr:GameObject.Weapon.PlayerThrowable):void {
			thr.place(x, y);
		}
		/////////////////////////////////////////////////////////////////
		////////////////////////GETTERS//////////////////////////////////
		/////////////////////////////////////////////////////////////////
		
		public function getButtonValidate():String { return m_stringValidate; }
		public function getButtonNext():String { return m_stringNext; }
		public function getButtonPrevious():String { return m_stringPrevious; }
		
		public function getWeapon():GameObject.Weapon.Sword {
			return m_equipement.m_weapon;
		}
		
		public function getArmor():GameObject.Armor.Armor {
			return m_equipement.m_armor;
		}
		
		public function isOnSpecial():Boolean {
			return m_onSpecial;
		}
		
		public function isCarryingPlayer():Boolean { return false; }
		
		public function getThrowable():PlayerThrowable {
			var thr:PlayerThrowable;
			for (var i:int = 0; i < m_throwables.length; i++) {
				if (m_throwables[i].isFree()) {
					thr = m_throwables[i];
					break;
				}
			}
			return thr;
		}
		
		public function getMagic():GameObject.Magic.Magic {
			return m_currentMagic;
		}
		
		public function freeScrollBlocking():void {
			m_scrollBlockDown = false;
			m_scrollBlockLeft = false;
			m_scrollBlockUp = false;
			m_scrollBlockRight = false;
		}
		
		protected function isToUpdate():Boolean {
			if(Global.nbPlayers == 2)
				return true;
			if (Global.soloPlayer.m_name == this.m_name)
				return true;
			x = Global.soloPlayer.x; y = Global.soloPlayer.y;
			m_oldPos.x = x; m_oldPos.y = y;
			return false;
		}
		
		public function setThrowablesPierce(canPierce:Boolean):void {
			for (var i:int = 0; i < m_throwables.length ; i++)
				m_throwables[i].m_collideEvtFree = canPierce;
		}
		
		public function hasFallen():Boolean { return false; }
		
		override public function twinkle():void {
			if (m_timerTwinkle.finished)
				return;
				
			if (m_timerTwinkle.progress > 0.9){
				alpha = 1;
				_twinkleOn = false;
			}else {
				var currentTwinkle:Number = _twinkleStep * _twinkleCount;
				var nextTwinkle:Number = currentTwinkle + _twinkleStep;
				
				if ( !_twinkleOn ) {
					if (m_timerTwinkle.progress > currentTwinkle && m_timerTwinkle.progress < nextTwinkle) {
						alpha = 0;
						_twinkleOn = true;
						_twinkleCount++;
					}
				}else {
					if (m_timerTwinkle.progress > currentTwinkle && m_timerTwinkle.progress < nextTwinkle) {
						alpha = 1;
						_twinkleOn = false;
						_twinkleCount++;
					}
				}
			}
		}
	}	
}
	
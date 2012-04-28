package GameObject 
{
	import GameObject.Armor.Armor;
	import GameObject.Enemy.Enemy;
	import GameObject.Equipement;
	import GameObject.Item.Item;
	import GameObject.Item.ItemManager;
	import GameObject.Magic.Magic;
	import GameObject.Magic.MovableMagic;
	import GameObject.Weapon.Sword;
	import GameObject.Weapon.Throwable;
	import GameObject.Weapon.Weapon;
	import InfoObject.InfoDamage;
	import org.flixel.FlxG;
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
		public var m_equipement:Equipement;
		
		public var m_throwables:Vector.<GameObject.Weapon.Throwable>;
		
		public var m_magics:Vector.<Magic>;
		public var m_currentMagic:GameObject.Magic.Magic = null;
		
		public var m_itemManager:GameObject.Item.ItemManager;
		
		public var m_timerDefense:FlxTimer;
		public var m_timerMagicCast:FlxTimer;
		private var m_timerAttack2:FlxTimer;
		
		//keys
		protected var m_stringValidate:String;
		protected var m_stringPrevious:String;
		protected var m_stringNext:String;
		
		public var m_scrollBlockUp:Boolean = false;
		public var m_scrollBlockDown:Boolean = false;
		public var m_scrollBlockRight:Boolean = false;
		public var m_scrollBlockLeft:Boolean = false;
		
		//SOUNDS
		public var FX_shieldClang:FlxSound;
		public var FX_drawWeapon:FlxSound;
		
		public var m_enemies:Vector.<GameObject.Enemy.Enemy>;
		
		public function PlayableObject(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_typeName = "Player";
			m_width = 24;
			m_height = 32;
			m_state = "idle";
			m_equipement = new GameObject.Equipement;
			m_magics = new Vector.<Magic>;
			m_stats = new GameObject.Stats();
			m_timerDefense = new FlxTimer();
			m_timerMagicCast = new FlxTimer();
			m_timerAttack2 = new FlxTimer();
			//SOUNDS
			FX_shieldClang = new FlxSound();
			FX_drawWeapon = new FlxSound();
			m_magics.push(Magic.Tornado());
			m_magics.push(Magic.Fireball());
			m_itemManager = new GameObject.Item.ItemManager(this);
			m_throwables = new Vector.<GameObject.Weapon.Throwable>();
			createThrowables();
			getWeapon().m_player = this;
		}
		
		public function createThrowables() :void {
			var thr:Throwable = m_equipement.m_throwable;
			thr.m_enemies = m_enemies;
			thr.setCasterPlayer(this);
			m_throwables.push(thr);
			for (var i:int = 0; i < 15; i++) {
				thr = Throwable.Slipper();
				thr.m_enemies = m_enemies;
				thr.setCasterPlayer(this);
				m_throwables.push(thr);
			}
		}
		
		public function loadThrowables() : void {
			for (var i:int = 0; i < m_throwables.length; i++) {
				m_throwables[i].load();
			}
		}
				
		public function getEnemiesInScene():void {
			m_enemies = Global.currentState.m_enemies;
		}
		/**
		 * Add Bitmaps of all the elements of the object
		 */
		override public function addBitmap():void {
			super.addBitmap();
			for (var i:int = 0; i < m_magics.length; i++){
				m_magics[i].addBitmap();
				m_magics[i].setCasterPlayer(this);
			}
			m_equipement.addToLibrary();
			m_itemManager.addToLibrary();
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.addPlayer(this);
			//add the equipement
			m_equipement.addToStage();
		}
		
		override public function load():void {
			super.load();
			m_equipement.load();
			//sounds
			FX_shieldClang.loadStream("FX/clang.mp3");
			FX_drawWeapon.loadStream("FX/swordDrawn.mp3");
			//magic
			for (var i:int = 0; i < m_magics.length; i++){
				m_magics[i].load();
			}
			m_itemManager.load();
			loadThrowables();
		}
		
		override public function isBusy():Boolean {
			return (m_state == "attack") || (m_state == "attack2") || (m_state == "defense") || (m_state == "magic") || (m_state == "item");
		}
		
		public function isAttacking():Boolean {
			return (m_state == "attack") || (m_state == "attack2") || (m_state == "waitForAttack2");
		}
		
		public function attack():void {
			if (isBusy())
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
				case UP : getWeapon().place(x,y - getWeapon().m_height); break;
				case DOWN :getWeapon().place(x,y+m_height); break;
				case RIGHT :getWeapon().place(x+m_width, y); break;
				case LEFT :getWeapon().place( x-getWeapon().m_width,y); break;
			}
		}
		
		public function throwIt():void {
			m_state = "throw";
			play("throw" + facing, true);
		}
		
		public function magicAttack(i:int):void {
			if (i >= m_magics.length || isBusy())
				return;
			m_currentMagic = m_magics[i];
			m_timerMagicCast.start(m_currentMagic.m_castingTime);
			m_state = "magic";
			play(m_state + facing);
		}
		
		public function useItem() :void {
			m_state = "item";
			play("item");
		}
		
		override public function update():void {
			switch(m_state) {
				case "attack": if (finished) {
									m_state = "waitForAttack2"; 
									m_timerAttack2.start(0.5); 
								}
								break;
				case "waitForAttack2": if (m_timerAttack2.finished) { m_state = "idle"; getWeapon().Idleize(); } break;
				case "attack2" : if (finished) { m_state = "idle"; getWeapon().Idleize();} break;
				case "idle":  break;
				case "throw": if (finished){
									m_state = "idle"; 
									var thr:GameObject.Weapon.Throwable = getThrowable();
									if (!thr) break;
									thr.place(x,y);
									thr.attack(facing);
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
				default : break;
			}
			//to move the player
			getMoves();
		}
		
		public function getMoves():void {
			if (FlxG.keys.justPressed(m_stringValidate) ){
				throwIt();
			}else if (FlxG.keys.justPressed(m_stringNext) ){
				attack();
			}
		}
		override public function move():void {
			if (isBusy() || isAttacking())
				return;
			super.move();
		}
		
		public function takeDamage(enemy:GameObject.Enemy.Enemy,weapon:Weapon = null):void {
			if (m_state == "defense") {
				FX_shieldClang.play();
				return;
			}
			//start timer during when the enemy is hit
			//m_timerHit.start(m_timeHit);
			//m_state = "hit";
			//calculate damage
			var damage:int;
			if(!weapon)
				damage = enemy.m_stats.m_attack_current - getArmor().m_defense;
			else
				damage = enemy.m_stats.m_attack_current + weapon.m_power - getArmor().m_defense;
			damage = damage * Utils.random(0.95, 1.05) - m_stats.m_defense_current ;
			//display damage
			var info:InfoDamage = new InfoDamage(x, y, String(damage));
			info.color = 0xFF8000;
			info.addToStage();
			//substract damage to hp
			m_stats.m_hp_current -= damage;
		}
		
		public function takeMagicDamage(enemy:Enemy, magic:Magic):void {
			//start timer during when the enemy is hit
			//m_timerHit.start(m_timeHit);
			m_state = "hit";
			//calculate damage
			var damage:int = magic.m_power + enemy.m_stats.m_magic_attack_current ;
			damage = damage * Utils.random(0.9, 1.1) - m_stats.m_magic_defense_current;
			//display damage
			var info:InfoDamage = new InfoDamage(x, y, String(damage));
			info.addToStage();
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
			Global.currentState.loadNewBitmaps(magic);
		}
		
		/**
		 * Adds a new item to the player ItemManager
		 * @return
		 */
		public function addItem(item:String,qty:int) : void {
			m_itemManager.addItem(item, qty);
		}
		/////////////////////////////////////////////////////////////////:
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
		
		public function getThrowable():GameObject.Weapon.Throwable {
			var thr:GameObject.Weapon.Throwable;
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
	}	
}
	
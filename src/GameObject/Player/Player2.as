package GameObject.Player 
{
	import GameObject.DrawableObject;
	import GameObject.GameObject;
	import GameObject.Menu.Menu;
	import GameObject.Other.Box;
	import GameObject.PlayableObject;
	import GameObject.Tile.Hole;
	import GameObject.TileObject;
	import GameObject.Weapon.PlayerThrowable;
	import GameObject.Weapon.Throwable;
	import GameObject.Weapon.Weapon;
	import org.flixel.FlxG;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class Player2 extends PlayableObject
	{		
		private var m_controlMgmt:Object;
		public var m_boxes:Vector.<Box>;
		public var m_objectCarried:DrawableObject;
		
		public function Player2(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, null);
			m_url = "Images/Players/touky.png";
			Global.player2 = this;
			m_width = 48;
			m_height = 48;
			/*
			m_stringValidate = "NUMPADONE";
			m_stringNext = "NUMPADTWO";
			m_stringPrevious = "NUMPADTHREE";*/
			setHitbox(16, 16, 16, 16);
			if(Global.nbPlayers == 2){
				m_stringValidate = "K";
				m_stringNext = "L";
				m_stringPrevious = "M";	
			}
			
			m_equipement.m_throwable = PlayerThrowable.Egg();
			m_equipement.m_weapon.visible = false;
			setHitbox(8, 14, 31, 24);
			m_name = "Player2";
			if (Global.nbPlayers == 1){
				visible = false;
				m_controlMgmt = process1playerControl;
				m_stringNext = Global.player1.m_stringNext;
				m_stringPrevious = Global.player1.m_stringPrevious;
				m_stringValidate = Global.player1.m_stringValidate;
			}else {
				m_controlMgmt = process2playerControl;
			}
			
			m_camembert = new GameObject.Menu.Camembert(this);
		}
		
		override public function getEnemiesInScene():void {
			super.getEnemiesInScene();
			m_boxes = Global.currentPlaystate.m_boxes;
		}
		
		override public function createThrowables():void {
			m_throwables = new Vector.<PlayerThrowable>();
			var thr:PlayerThrowable;
			for (var i:int = 0; i < 15; i++) {
				thr = PlayerThrowable.Egg();
				thr.m_enemies = m_enemies;
				thr.setCaster(this);
				m_throwables.push(thr);
			}
		}
		
		override public function load():void {
			super.load();
			m_otherPlayer = Global.player1;
			//IDLE ANIM
			addAnimation("idle" + UP, [18,19,20,19], 15, true);
			addAnimation("idle" + RIGHT, [0,1,2,1], 15, true);
			addAnimation("idle" + DOWN, [12,13,14,13], 15, true);
			addAnimation("idle" + LEFT, [6,7,8,7], 15, true);
			//walk anim
			addAnimation("walk" + UP, [18,19,20,19], 25, true);
			addAnimation("walk" + RIGHT, [0,1,2,1], 25, true);
			addAnimation("walk" + DOWN, [12,13,14,13], 25, true);
			addAnimation("walk" + LEFT, [6,7,8,7], 25, true);	
			//attack anim
			addAnimation("attack" + UP, [33,34,35], 10, false);
			addAnimation("attack" + RIGHT, [24,25,26], 10, false);
			addAnimation("attack" + DOWN, [30,31,32], 10, false);
			addAnimation("attack" + LEFT, [27,28,29], 10, false);
			//attack anim
			addAnimation("attack2" + UP, [35,34,33], 10, false);
			addAnimation("attack2" + RIGHT, [26,25,24], 10, false);
			addAnimation("attack2" + DOWN, [32,31,30], 10, false);
			addAnimation("attack2" + LEFT, [29,28,27], 10, false);
			//throw anim
			addAnimation("throw" + UP, [21,22], 12, false);
			addAnimation("throw" + RIGHT,[3,4], 12, false);
			addAnimation("throw" + DOWN, [15, 16], 12, false);
			addAnimation("throw" + LEFT, [9,10], 12, false);
			//rush anim
			addAnimation("rush" + UP, [23], 10, false);
			addAnimation("rush" + RIGHT, [5], 10, false);
			addAnimation("rush" + DOWN, [17], 10, false);
			addAnimation("rush" + LEFT, [11], 10, false);
		}
				
		override public function getMoves():void {
			//check second attack
			if (FlxG.keys.justPressed(m_stringNext) && m_state == "waitForAttack2" )
				attack();
				
			if (isBusy() || m_blocked || m_state == "rushAttack")
				return;
			
			if (FlxG.keys.justPressed(m_stringPrevious)) {
				if(!m_onSpecial){
					triggerSpecial();
					return;
				}else{
					unspecial();
				}
			}
			//on special/AntySpecial state Touky can't shoot
			if (!m_onSpecial && m_state != "rushAttack"){
				if (FlxG.keys.justPressed(m_stringValidate) ){
					throwIt();
					return;
				}else if (FlxG.keys.justPressed(m_stringNext) ){
					attack();
					return;
				}
			}
			
			m_controlMgmt();
		
			play(m_state + facing);
			
			freeScrollBlocking();
		}
		
		override public function triggerSpecial():void {
			if (!m_timerSpecialAvailable.finished)
				return;
			var t_found:Boolean = false;
			if (!Global.soloPlayer && this.collide(Global.player1) ) {
				m_objectCarried = Global.player1;
				t_found = true;
			}else {
				for (var i:int = 0; i < m_boxes.length; i++) {
					if (collide(m_boxes[i])){
						m_objectCarried = m_boxes[i];
						t_found = true;
						break;
					}
				}
			}
			if (!t_found)
				return;
			m_onSpecial = true;
			if (Global.specialUnlimited) {
				m_timerSpecial = new FlxTimer();
				m_timerSpecial.start(Number.MAX_VALUE);
				//m_camembert.trigger(Number.MAX_VALUE,true);
			}else{
				m_timerSpecial = new FlxTimer();
				m_timerSpecial.start(10);
				m_camembert.trigger(10,true);
			}
		}
		
		override public function unspecial():void {
			if (!m_onSpecial)
				return;
			m_onSpecial = false;
			if (Global.specialUnlimited) {
				m_timerSpecialAvailable = new FlxTimer();
				m_timerSpecialAvailable.start(0.1);
				//m_camembert.trigger(0.1);
			}else {
				m_timerSpecialAvailable = new FlxTimer();
				m_timerSpecialAvailable.start(5);
				m_camembert.trigger(5);
			}
						
			if ( m_objectCarried == Global.player1 ) {
				var tiles:Array = Global.player1.tilesUnder();
				var i:int = 0;
				var find:Boolean = false;
				while ( i < tiles.length && find == false ) {
					var tile:int = tiles[i];
					if ( tile == TilesManager.HOLE_TILE ) {
						Global.player1.fallInWater();
						Global.player1.m_state = "waitToukyPosition";
						find = true;
					}
					i++;
				}
				if (Global.player1.m_state != "waitToukyPosition")
					Global.player1.replaceWithNoCollision();
			}
			if (m_objectCarried.m_typeName == "Box") {
				m_objectCarried.act();
				// APPELER FONCTION RESPAWN
				//m_objectCarried.respawn();
			}
			m_objectCarried = null;
		}
		
		override public function placeOtherPlayer():void {
			m_objectCarried.place(x, y + 15);
		}
		
		override public function triggerRushAttack(p1facing:uint ):void { 
			m_state = "rushAttack";
			facing = p1facing;
			play("rush" + facing);
		}
		
		override public function takeDamage():Boolean {
			if (Global.soloPlayer && Global.soloPlayer.m_name != m_name)
				return false;
			if (!m_timerTwinkle.finished || isRushing() || m_state == "respawn")
				return false;
			Global.menuPlayer2.takeDamage();
			FX_hit.play();
			//start timer during when the enemy is hit
			changeTwinkleColor(_twinkleHit);
			beginTwinkle(20, 1.5);
			m_stats.m_hp_current --;
			//if no more health
			if (m_stats.m_hp_current <= 0 ) {
				unspecial();
				if(m_lifes > 0 || m_otherPlayer.m_lifes >0){ 
					respawn();
				}else{
					die();
					return false;
				}
			}
			return true;
		}
		
		override public function isCarryingPlayer():Boolean { 
			if (m_objectCarried && m_objectCarried.m_name == Global.player1.m_name)
				return true;
			return false; 
		}
		
		override public function throwBullet():void {
			m_state = "idle"; 
			var thr:PlayerThrowable = getThrowable();
			if (!thr) return;
			if (m_superShot || Global.superUnlimited) {
				thr.m_explosive = true;
				m_superShotCount --;
				if (m_superShotCount == 0)
					m_superShot = false;
			}
			if (!thr.m_rotative)
				thr.setAnimationWithDirection(m_directionFacing);
			placeThrowable(thr);
			thr.attack(facing);
		}
		
		/////////////////////////////////////////////////////////////////////////
		/////////// DONT LOOK AT THAT PLEASE///////////////////////////////////
		///////////////////////////////////////////////////////////////////////
		
		private function process1playerControl():void {
			
			//moving
			var yForce:int = 0;
			var xForce:int = 0;
			var pressedDirection:Boolean = false;
			
			if (FlxG.keys.Z) { 
				if(!m_scrollBlockUp){
					pressedDirection = true;
					yForce-= 1;
				}
				facing = UP;
			}
			if (FlxG.keys.S ) {
				if(!m_scrollBlockDown){
					pressedDirection = true;
					yForce += 1;
				}
				facing = DOWN;
			}
			if (FlxG.keys.Q ) {
				if(!m_scrollBlockLeft){
					pressedDirection = true;
					xForce -= 1;
				}
				facing = LEFT;
			}
			if (FlxG.keys.D ) {
				if(!m_scrollBlockRight){
					pressedDirection = true;
					xForce += 1;
				}
				facing = RIGHT;
			}
			if(pressedDirection){
				m_direction.x = xForce;
				m_direction.y = yForce;
				m_directionFacing = m_direction;
				if(m_state != "throw")
					m_state = "walk";
				move();
			}else {
				if(m_state != "throw" && m_state != "waitForAttack2")
					m_state = "idle";
			}
		}
		
		private function process2playerControl():void {
			
			//moving
			var yForce:int = 0;
			var xForce:int = 0;
			var pressedDirection:Boolean = false;
			
			if (FlxG.keys.UP) { 
				if(!m_scrollBlockUp){
					pressedDirection = true;
					yForce-= 1;
				}
				facing = UP;
			}
			if (FlxG.keys.DOWN ) {
				if(!m_scrollBlockDown){
					pressedDirection = true;
					yForce += 1;
				}
				facing = DOWN;
			}
			if (FlxG.keys.LEFT ) {
				if(!m_scrollBlockLeft){
					pressedDirection = true;
					xForce -= 1;
				}
				facing = LEFT;
			}
			if (FlxG.keys.RIGHT ) {
				if(!m_scrollBlockRight){
					pressedDirection = true;
					xForce += 1;
				}
				facing = RIGHT;
			}
			
			if(pressedDirection){
				m_direction.x = xForce;
				m_direction.y = yForce;
				m_directionFacing = m_direction;
				if(m_state != "throw")
					m_state = "walk";
				move();
			}else {
				if(m_state != "throw" && m_state != "waitForAttack2")
					m_state = "idle";
			}
		}
		
		override public function collideWithTileType(_type:int) : Boolean
		{
			var collide:Boolean = false;
			
			if (
			_type == TilesManager.PHYSICAL_TILE ||
			_type == TilesManager.PIPE_TILE
			)
			{
				collide = true;
			}
			
			return collide;
		}
	}

}
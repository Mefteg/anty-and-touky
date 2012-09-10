package GameObject.Enemy.Centipede 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import GameObject.Enemy.Enemy;
	import GameObject.PlayableObject;
	import GameObject.Weapon.Weapon;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxTimer;
	import Scene.Transition;
	/**
	 * ...
	 * @author ...
	 */
	public class Centipede extends Enemy 
	{
		private var TIME_WAIT_OUT:int = 3;
		private var TIME_WAIT_IN:int = 1;
		
		private var m_parts:Array;
		private var m_nbParts:int = 13;
		private var m_livingParts:int;
		private var m_area:Rectangle;
		
		private var m_spawnPoints:Array;
		private var m_currentSpawn:CentipedeSpawnPoint;
		
		private var m_timerWait:FlxTimer;
		
		private var m_initSpeed:Number;
		private var m_rageCount:int = 0;
		private var m_rage:Boolean = false;
		private var m_rageMax:int;
	
		private var m_dead:Boolean = false;
		
		private var m_stepSound:FlxSound;
		private var m_stepSound2:FlxSound;
		
		private var m_beginTransition:Transition;
		private var m_endTransition:Transition;
		
		public function Centipede(X:Number, Y:Number, areaWidth:int, areaHeight:int ) 
		{
			super(X, Y);
			m_url = "Images/Enemies/centipedeHead.png";
			m_width = 48;
			m_height = 32;
			m_speed = 3.0;
			m_initSpeed = m_speed;
			switch(Global.difficulty) {
				case 1: m_stats.initHP(5); m_nbParts = 10; break;
				case 2: m_stats.initHP(10);m_nbParts = 13; break;
				case 3: m_stats.initHP(15); m_nbParts = 15; break;
				default : m_stats.initHP(5); break;
			}			
			m_points = 1000;
			m_invincible = true;
			m_stepSound = new FlxSound();
			m_stepSound.loadStream("FX/centipede.mp3", true);
			m_stepSound2 = new FlxSound();
			m_stepSound2.loadStream("FX/centipede2.mp3", true);
			m_beginTransition = new Transition("Images/centipede.swf", 5, true);
			m_endTransition = new Transition("Images/entreetechnodrome.swf", 5, false);
			createParts();
			m_livingParts = m_nbParts;
			m_area = new Rectangle(X, Y, areaWidth, areaHeight);
			m_spawnPoints = new Array(
							new CentipedeSpawnPoint(new FlxPoint(X, Y+areaHeight*0.2), RIGHT,new FlxPoint(1,0.2)), // LEFT 1
							new CentipedeSpawnPoint(new FlxPoint(X, Y+areaHeight*0.4), RIGHT,new FlxPoint(1,0)), // LEFT 2
							new CentipedeSpawnPoint(new FlxPoint(X, Y+areaHeight*0.6), RIGHT,new FlxPoint(1,0)), // LEFT 3
							new CentipedeSpawnPoint(new FlxPoint(X, Y+areaHeight*0.8), RIGHT,new FlxPoint(1,-0.2)), //LEFT 4
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth-1, Y+areaHeight*0.2), LEFT,new FlxPoint(-1,0.1)), // RIGHT 1
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth, Y+areaHeight*0.4), LEFT,new FlxPoint(-1,0)), // RIGHT 2
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth-1, Y+areaHeight*0.6), LEFT,new FlxPoint(-1,0)), // RIGHT 3
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth-1, Y+areaHeight*0.8), LEFT,new FlxPoint(-1,-0.1)) // RIGHT
							);
			x = -150; y = -150;
			m_currentSpawn = new CentipedeSpawnPoint(new FlxPoint(x, y), LEFT, m_direction);
			placeParts();
			m_timerWait = new FlxTimer();
			m_state = "trans";
			m_timerWait.start(TIME_WAIT_OUT);
		}
			
		private function createParts():void {
			if (Global.soloPlayer)
				m_nbParts /= 2;
			m_parts = new Array();
			var part:CentipedePart;
			for (var i:int = 0; i < m_nbParts; i++) {
				part = new CentipedePart(this);
				m_parts.push(part);
			}
		}	
		
		override public function update() : void {
			if (Global.frozen)
				return;
			move();
			twinkle();
			if(!m_dead)
				checkPlayersDamage();
			switch(m_state) {
				case "trans" : if (m_beginTransition.isOver()) { m_state = "waitingOutside"; } break;
				case "waitingOutside": waitingOutside(); break;
				case "waitingInside": waitingInside(); break;
				case "moving" : moving(); break;
				case "stunned" : stunned(); break;
				case "spawning" : spawning(); break;
				case "dying": die(); break;
				case "ending": ending(); break;
				default : break;
			}
		}
		
		private function spawn(spPt:CentipedeSpawnPoint) {
			x = spPt.m_pos.x; y = spPt.m_pos.y;
			facing = spPt.m_facing;
			play("walk" + spPt.m_facing);
			m_currentSpawn = spPt;
			placeParts();
		}
		
		private function initPartsMove():void {
			for (var i:int = 0; i < m_nbParts; i++) {
				m_parts[i].m_direction = m_direction;
				m_parts[i].changeDirection(facing);
				m_parts[i].m_speed = m_speed;
			}
		}
		
		private function moveParts():void {
			for (var i:int = 0; i < m_nbParts; i++) {
				m_parts[i].move();
			}
		}
		
		private function getSpawnPoint():CentipedeSpawnPoint {
			var i:int = Utils.random(0, 7);
			return m_spawnPoints[i];
		}
		
		private function outOfArea() : Boolean {
			var obj:Enemy = m_parts[m_nbParts - 1];
			if (obj.y < m_area.y || obj.y > m_area.y + m_area.height)
				return true;
			if (facing == LEFT) {
				if (obj.x < m_area.x - obj.width)
					return true;
			}else {
				if (obj.x > m_area.x + m_area.width)
					return true;
			}
			return false;
		}
		
		//88888888888888888888888888888888888888888888//
		/////////  ACTIONS /////////////////////////////
		
		private function waitingOutside():void {
			//check rage & deactivate if over
			if (m_rage) {
				m_rageCount++;
				if (m_rageCount > m_rageMax) 
					unrage();
			}
			//if waited long enough or in rage
			if (m_timerWait.finished || m_rage) {
				m_timerWait.start(TIME_WAIT_IN);
				m_state = "waitingInside";
				spawn(getSpawnPoint());
			}
		}
		
		private function waitingInside():void {
			if (m_timerWait.finished || m_rage) {
				m_state = "moving";
				// Randomly go its way (30%) or go to one player (70%)
				var r:Number = Utils.random(0, 100);
				if(r<30){
					m_direction = m_currentSpawn.m_dir;
				}else {
					goTo(getRandomPlayer());
				}
				initPartsMove();
				m_stepSound.play();
				m_stepSound2.play();
			}
		}
		
		private function spawning():void {
			
		}
		
		private function moving():void {
			moveParts();
			if (outOfArea()) {
				x = -150; y = -150;
				hideParts();
				m_direction = new FlxPoint(0, 0);
				m_state = "waitingOutside";
				m_timerWait.start(TIME_WAIT_OUT);
				m_stepSound.stop();
				m_stepSound2.stop();
			}
				
		}
		
		private function stunned():void {
			if (m_timerWait.finished) {
				m_state = "moving";
			}
		}
		
		private function triggerRage():void {
			m_rage = true;
			m_speed *= 2;
			m_rageCount = 0;
			m_rageMax = Utils.random(3, 5);
			for (var i:int = 0; i < m_nbParts; i++)
				m_parts[i].m_speed = m_speed;
		}
		
		private function unrage():void {
			m_rage = false;
			m_speed = m_initSpeed;
			for (var i:int = 0; i < m_nbParts; i++)
				m_parts[i].m_speed = m_initSpeed;
		}
		
		//OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO//
		///////////////////// PLACE PARTS //////////////////
		//OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO//
		
		private function placeParts():void {
			switch(m_currentSpawn.m_facing) {
				case LEFT : placePartsToRight(); break;
				case RIGHT : placePartsToLeft(); break;
				default : break;
			}
		}
		
		private function placePartsToLeft():void {
			var part:CentipedePart;
			for (var i:int = 0; i < m_nbParts; i++) {
				part = m_parts[i];
				part.x = x -24; part.y = y;
				part.x -= (part.m_width -8 ) * i ;
			}
		}
		
		private function placePartsToRight():void {
			var part:CentipedePart;
			for (var i:int = 0; i < m_nbParts; i++) {
				part = m_parts[i];
				part.x = x + m_width -7; part.y = y;
				part.x += (part.m_width -8 ) * i ;
			}
		}
		private function placePartsToUpRight():void {
			
		}
		private function placePartsToUpLeft():void {
			
		}
		private function placePartsToDownRight():void {
			
		}
		private function placePartsToDownLeft():void {
			
		}
		
		private function hideParts():void {
			var part:CentipedePart;
			for (var i:int = 0; i < m_nbParts; i++) {
				part = m_parts[i];
				part.x = -150; part.y = -150;
			}
		}
		
		public function removePart():void {
			m_livingParts --;
			if (m_livingParts == 0) {
				m_invincible = false;
			}
			if (!m_rage)
				triggerRage();
			if (m_livingParts == m_nbParts * 0.5)
				m_initSpeed += 0.2;
		}
		
		public function killParts():void {
			for (var i:int = 0; i < m_nbParts; i++)
				m_parts[i].die();
		}
		////////////////////////////////////////////////
		////////////LOADING/////////////////////////::
		override public function addToStage() : void {
			super.addToStage();
			for (var i:int = 0; i < m_nbParts; i++)
				m_parts[i].addToStage();
			m_beginTransition.play();
		}
				
		override public function addBitmap():void {
			super.addBitmap();
			m_parts[0].addBitmap();
		}
		
		override public function load():void {
			super.load();
			
			for (var i:int = 0; i < m_nbParts; i++)
			m_parts[i].load();
				
			addAnimation("walk" + RIGHT, [1], 5, false);
			addAnimation("walk" + LEFT, [0], 5, false);
			
			play("walk" + LEFT);
		}
		
		override public function move() : void {
			if (m_state == "stunned")
				return;
			m_direction = Utils.normalize(m_direction);
			m_oldPos.x= this.x;
			m_oldPos.y = this.y;
			
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
			
		}
		
		override public function takeDamage(player:PlayableObject, weapon:Weapon):void
		{	
			if (m_invincible)
				return;
			//calculate damage
			var damage:int = weapon.m_power;
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			m_FXhit.play();
			//check death
			if (m_stats.m_hp_current <= 0)
			{
				triggerDeath();
				if (!Global.soloPlayer)
					m_killer = player;
			}
			//for twinkling
			changeTwinkleColor(_twinkleHit);
			beginTwinkle(3, 0.3);
		}
		
		override protected function takeRushDamage(player:PlayableObject):void {
			if (m_invincible) {
				m_timerWait.start(1.5);
				m_state = "stunned";
				return;
			}
			//calculate damage
			var damage:int = 5 ;
			//substract damage to hp
			m_stats.m_hp_current -= damage;
			//check death
			if (m_stats.m_hp_current <= 0){
				triggerDeath();
				if (!Global.soloPlayer)
					m_killer = player;
			}
			//for twinkling
			changeTwinkleColor(_twinkleHit);
			beginTwinkle(3, 0.3);
		}
		
		public function triggerDeath():void {
			m_dead = true;
			m_state = "dying";
			m_direction = new FlxPoint(0, 0);
			m_invincible = true;
			m_stepSound.stop();
			m_stepSound2.stop();
			killParts();
			m_timerDeath.start(2);
		}
		
		override public function die():void {
			if (m_timerDeath.finished) {
				m_state = "ending";
				m_timerDeath.start(10);
				Global.currentPlaystate.chargeMusic("GoodGameBro",false);
				m_smoke.playSmoke(x+6, y-4);
				visible = false;
				if(m_killer)
					m_killer.addScore(m_points);
			}
		}
		
		private function ending():void {
			if (m_timerDeath.finished){
				Global.currentPlaystate.changeScene("Maps/W3M1.json", "init");
				m_endTransition.play();
				m_state = "pitiful";
			}
		}
		
	}

}
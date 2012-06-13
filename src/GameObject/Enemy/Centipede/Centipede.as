package GameObject.Enemy.Centipede 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import GameObject.Enemy.Enemy;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class Centipede extends Enemy 
	{
		private var TIME_WAIT_OUT:int = 4;
		private var TIME_WAIT_IN:int = 1;
		
		private var m_parts:Array;
		private var m_nbParts:int = 6;
		private var m_area:Rectangle;
		
		private var m_spawnPoints:Array;
		private var m_currentSpawn:CentipedeSpawnPoint;
		
		private var m_timerWait:FlxTimer;
		
		public function Centipede(X:Number, Y:Number, areaWidth:int, areaHeight:int ) 
		{
			super(X, Y);
			m_url = "Images/Enemies/centipedeHead.png";
			m_width = 48;
			m_height = 32;
			m_speed =2.5;
			createParts();
			m_area = new Rectangle(X, Y, areaWidth, areaHeight);
			m_spawnPoints = new Array(
							new CentipedeSpawnPoint(new FlxPoint(X+1, Y-1), RIGHT,new FlxPoint(1,-1)), // UP LEFT
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth-1, Y), LEFT,new FlxPoint(-1,1)), // UP RIGHT
							new CentipedeSpawnPoint(new FlxPoint(X, Y+areaHeight*0.3), RIGHT,new FlxPoint(1,0)), // LEFT 1
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth, Y+areaHeight*0.3), LEFT,new FlxPoint(-1,0)), // RIGHT 1
							new CentipedeSpawnPoint(new FlxPoint(X+1, Y+height*0.6), RIGHT,new FlxPoint(1,0)), // LEFT 2
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth-1, Y+areaHeight*0.6), LEFT,new FlxPoint(-1,0)), // RIGHT 2
							new CentipedeSpawnPoint(new FlxPoint(X+1, Y+height-1), RIGHT,new FlxPoint(1,-1)), // DOWN LEFT
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth-1, Y+areaHeight-1), LEFT,new FlxPoint(-1,-1)) // DOWN RIGHT
							);
			spawn(m_spawnPoints[1]);
			placeParts();
			m_timerWait = new FlxTimer();
			m_state = "waitingOutside";
			m_timerWait.start(TIME_WAIT_OUT);
		}
			
		private function createParts():void {
			m_parts = new Array();
			var part:CentipedePart;
			for (var i:int = 0; i < m_nbParts; i++) {
				part = new CentipedePart(0, 0);
				m_parts.push(part);
			}
		}	
		
		override public function update() : void {
			if (Global.frozen)
				return;
			move();
			switch(m_state) {
				case "waitingOutside": waitingOutside(); break;
				case "waitingInside": waitingInside(); break;
				case "moving" : moving(); break;
				case "spawning" : spawning(); break;
				default : break;
			}
		}
		
		private function spawn(spPt:CentipedeSpawnPoint) {
			x = spPt.m_pos.x; y = spPt.m_pos.y;
			play("walk" + spPt.m_facing);
			m_currentSpawn = spPt;
			placeParts();
		}
		
		private function initPartsMove():void {
			for (var i:int = 0; i < m_nbParts; i++) {
				m_parts[i].m_direction = m_direction;
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
			//TO DO : if( !obj.OnScreen())
			var obj:Enemy = m_parts[m_nbParts - 1];
			if (obj.x > m_area.x + 800 ||  obj.x < m_area.x -300)
				return true;
			if (obj.y < 0 ||  obj.y > m_area.y +600)
				return true;
			return false;
		}
		
		//88888888888888888888888888888888888888888888//
		/////////  ACTIONS /////////////////////////////
		
		private function waitingOutside():void {
			if (m_timerWait.finished) {
				m_timerWait.start(TIME_WAIT_IN);
				m_state = "waitingInside";
				spawn(getSpawnPoint());
			}
		}
		
		private function waitingInside():void {
			if (m_timerWait.finished) {
				m_state = "moving";
				m_direction = m_currentSpawn.m_dir;
				initPartsMove();
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
			}
				
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
				part.x = x -17; part.y = y;
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
		
		////////////////////////////////////////////////
		////////////LOADING/////////////////////////::
		override public function addToStage() : void {
			super.addToStage();
			for (var i:int = 0; i < m_nbParts; i++)
				m_parts[i].addToStage();
		}
		
		override public function removeFromStage():void {
			super.removeFromStage();
			for (var i:int = 0; i < m_nbParts; i++)
				m_parts[i].removeToStage();
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
			m_oldPos.x= this.x;
			m_oldPos.y = this.y;
			
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
			
		}
		
	}

}
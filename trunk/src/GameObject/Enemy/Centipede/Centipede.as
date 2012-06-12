package GameObject.Enemy.Centipede 
{
	import flash.geom.Rectangle;
	import GameObject.Enemy.Enemy;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class Centipede extends Enemy 
	{
		private var m_parts:Array;
		private var m_nbParts:int = 6;
		private var m_area:Rectangle;
		
		private var m_spawnPoints:Array;
		
		public function Centipede(X:Number, Y:Number, areaWidth:int, areaHeight:int ) 
		{
			super(X, Y);
			m_url = "Images/Enemies/centipedeHead.png";
			m_width = 48;
			m_height = 32;
			createParts();
			m_area = new Rectangle(X, Y, areaWidth, areaHeight);
			m_spawnPoints = new Array(
							new CentipedeSpawnPoint(new FlxPoint(X, Y), RIGHT), // UP LEFT
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth, Y), LEFT), // UP RIGHT
							new CentipedeSpawnPoint(new FlxPoint(X, Y+areaHeight*0.3), RIGHT), // LEFT 1
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth, Y+areaHeight*0.3), LEFT), // RIGHT 1
							new CentipedeSpawnPoint(new FlxPoint(X, Y+height*0.6), RIGHT), // LEFT 2
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth, Y+areaHeight*0.6), LEFT), // RIGHT 2
							new CentipedeSpawnPoint(new FlxPoint(X, Y+height), RIGHT), // DOWN LEFT
							new CentipedeSpawnPoint(new FlxPoint(X+areaWidth, Y+areaHeight), LEFT) // DOWN RIGHT
							);
			//m_direction.x = -1;
			spawn(m_spawnPoints[1]);
		}
			
		private function createParts():void {
			m_parts = new Array();
			var part:CentipedePart;
			for (var i:int = 0; i < m_nbParts; i++) {
				part = new CentipedePart(x + m_width -7 , y);
				part.x += (part.m_width -8 ) * i ;
				m_parts.push(part);
			}
		}	
		
		override public function update() : void {
			if (FlxG.keys.A)
				m_direction.x = -1.5;
			move();
			moveParts();
		}
		
		private function spawn(spPt:CentipedeSpawnPoint) {
			x = spPt.m_pos.x; y = spPt.m_pos.y;
		}
		
		private function moveParts():void {
			for (var i:int = 0; i < m_nbParts; i++) {
				m_parts[i].m_direction = m_direction;
				m_parts[i].move();
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
				
			addAnimation("walk" + UP, [1,2,3], 5, true);
			addAnimation("walk" + RIGHT, [0], 5, true);
			addAnimation("walk" + DOWN, [9], 5, true);
			addAnimation("walk" + LEFT, [1, 2, 3], 5, true);
			
			play("walk" + LEFT);
		}
		
	}

}
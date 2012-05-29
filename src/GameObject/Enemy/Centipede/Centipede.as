package GameObject.Enemy.Centipede 
{
	import GameObject.Enemy.Enemy;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author ...
	 */
	public class Centipede extends Enemy 
	{
		private var m_parts:Array;
		private var m_nbParts:int = 6;
		
		public function Centipede(X:Number,Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Enemies/centipedeHead.png";
			m_width = 48;
			m_height = 32;
			createParts();
			//m_direction.x = -1;
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
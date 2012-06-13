package GameObject.Enemy.Centipede 
{
	import GameObject.Enemy.Enemy;
	/**
	 * ...
	 * @author ...
	 */
	public class CentipedePart extends Enemy
	{
		
		public function CentipedePart(X:Number, Y:Number ) 
		{
			super(X, Y);
			m_url = "Images/Enemies/centipedePart.png";
			m_width = 32;
			m_height = 32;
		}
		
		override public function load():void {
			super.load();
			//walk anim
			addAnimation("walk" + RIGHT, [5,6,7], 15, true);
			addAnimation("walk" + LEFT, [1, 2, 3], 15, true);
			
			play("walk" + LEFT);
		}
		
		override public function update() : void {
			commonEnemyUpdate();
		}
		
		override public function move() : void {
			m_oldPos.x= this.x;
			m_oldPos.y = this.y;
			
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
			
		}
	}

}
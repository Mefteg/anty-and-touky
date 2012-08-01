package GameObject.Enemy 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Snake extends Enemy 
	{
		
		public function Snake(X:Number,Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Enemies/snake.png";
			m_width = 32; m_height = 32;
			m_points = 15;
			m_activeOffscreen = true;
			m_stats.initHP(1);
			setHitbox(6, 6, 24, 24);
		}
		
		
		override public function load():void {
			super.load();
			addAnimation(LEFT.toString(),[0,1,2],10)
			addAnimation(RIGHT.toString(), [3, 4, 5], 10);
			addAnimation(DOWN.toString(), [6, 7, 8], 10);
			addAnimation(UP.toString(), [9, 10, 11], 10);
		}
		
		override public function move() : void {
			m_oldPos.x= this.x;
			m_oldPos.y = this.y;
			
			this.x = this.x + (m_direction.x * m_speed);
			this.y = this.y + (m_direction.y * m_speed);
			
			var collided:Boolean = false;
			if ( this.collideWithEnv() ) {
				collided = true;
				this.x = m_oldPos.x;
			}
			if ( this.collideWithEnv() ) {
				collided = true;
				this.y = m_oldPos.y;
			}
			if (collided) {
				if (!onScreen())
					removeFromStage();
				m_direction.x *= -1;
				m_direction.y *= -1;
			}
			
			if (m_direction.x < 0) facing = LEFT;
			else if (m_direction.x > 0) facing = RIGHT;
			else if (m_direction.y < 0) facing = UP;
			else if (m_direction.y > 0) facing = DOWN;
			play(facing.toString());
		}
		
		override public function update():void {
			commonEnemyUpdate();
			m_direction = m_directionFacing;
			move();
			if (m_state == "dead")
				die();
		}
	}

}
package GameObject.Enemy 
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class Mosquito extends FlyingEnemy 
	{
		
		public function Mosquito(X:Number,Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Enemies/mosquito.png";
			m_width = 32; m_height = 32;
			m_activeOffscreen = true;
			m_stats.initHP(1);
			setHitbox(5, 7, 18, 17);
			m_canGoThrough = false;
			m_points = 10;
			m_smoke.scale = new FlxPoint(0.8, 0.8);
		}
		
		override public function load():void {
			super.load();
			addAnimation("fly", [0, 1], 20, true);
			play("fly");
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
		}
		
		override public function update():void {
			commonEnemyUpdate();
			m_direction = m_directionFacing;
			move();
			if (m_state == "dead")
				die();
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
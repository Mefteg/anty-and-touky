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
		
		override public function update():void {
			commonEnemyUpdate();
			m_direction = m_directionFacing;
			move();
			if (m_state == "dead")
				die();
		}
		
	}

}
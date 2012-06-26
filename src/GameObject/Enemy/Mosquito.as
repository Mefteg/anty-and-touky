package GameObject.Enemy 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Mosquito extends Enemy 
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
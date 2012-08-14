package GameObject.Item 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Life extends Collectable 
	{
		
		public function Life(X:Number, Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Items/life.png";
			m_height = 32; m_width = 32;
		}
		
		override public function load():void {
			super.load();
			addAnimation("glow", [0, 1, 2,3], 10, true);
			play("glow");
		}
		
		override public function act():void {
			m_target.m_lifes += 1;
			removeFromStage();
		}
		
	}

}
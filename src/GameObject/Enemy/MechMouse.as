package GameObject.Enemy 
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class MechMouse extends Snake 
	{
		
		public function MechMouse(X:Number,Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Enemies/mouseMech.png";
			setHitbox(8, 10, 16, 14);
			m_smoke.scale = new FlxPoint(0.5, 0.5);
		}
		
	}

}
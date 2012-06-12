package GameObject.Enemy.Centipede 
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class CentipedeSpawnPoint 
	{
		public var m_pos:FlxPoint;
		public var m_facing:uint;
		
		public function CentipedeSpawnPoint(pos:FlxPoint, facing:uint ) 
		{
			m_pos = pos;
			m_facing = facing;
		}
		
	}

}
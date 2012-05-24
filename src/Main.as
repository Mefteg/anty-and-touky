package 
{
	import org.flixel.FlxGame;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Main extends FlxGame 
	{
		public function Main():void 
		{
			//super(640, 480, Menustate, 1);
			super(640, 480, Playstate, 1);
		}
	}
	
}
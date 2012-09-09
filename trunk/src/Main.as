package 
{
	import flash.events.Event;
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
			//super(640, 480, Playstate, 1);
			//super(640, 480, StoryState, 1);
			//super(640, 480, GameOverstate, 1);
			super(640, 480, Victorystate, 1);
		}
		
		override protected function create(FlashEvent:Event) : void
        {
            super.create(FlashEvent);
            stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
            stage.removeEventListener(Event.ACTIVATE, onFocus);
        }
	}
	
}
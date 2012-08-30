package  
{
	import GameObject.Menu.MenuBegin;
	import GameObject.Menu.MenuOptions;
	import org.flixel.FlxInputText;
	import org.flixel.FlxText;
	import Scene.Library;
	/**
	 * ...
	 * @author ...
	 */
	public class Optionsstate extends State 
	{
		protected var m_menuOptions:MenuOptions;
		
		protected var m_textField:FlxInputText;
		
		public function Optionsstate()
		{
			m_state = "Loading";
			
			m_library = new Library();
			Global.library = m_library;
			m_uniquesLoaded = false;
			depthBuffer = new DepthBuffer();
			add(depthBuffer);
			Global.currentState = this;
			//text displaying loading advancement
			m_loadProgression = new FlxText(400, 400, 600);
			add(m_loadProgression);
			//text field
			m_textField = new FlxInputText(0, 0, 100, 10, "Your cheat here");
			add(m_textField);
		}
		
		override public function create() : void {
			super.create();
			
			m_menuOptions = new MenuOptions();
			m_menuOptions.addToStage();
		}
		
		override public function update() :void{
			super.update();
		}
		
		override protected function loading() : void {
			super.loading();
			//charge all the bitmaps in the library
			Global.library.loadAll();
			//when the bitmaps are loaded
			if (Global.library.loadComplete()) {
				//cache them
				Global.library.cacheObjects();
				//load the graphics
				m_menuOptions.load();
				m_state = "Loaded";
			}
			
		}
		
	}

}
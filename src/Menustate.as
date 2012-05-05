package  
{
	import GameObject.DrawableObject;
	import GameObject.Menu.MenuBegin;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import Scene.Library;
	import Scene.SceneManager;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Menustate extends State 
	{
		protected var m_menuBegin:MenuBegin;

		public function Menustate() 
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
		}
		
		override public function create() : void {
			super.create();
			
			m_menuBegin = new MenuBegin();
			m_menuBegin.addToStage();
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
				m_menuBegin.load();
				m_state = "Loaded";
			}
			
		}
	}

}
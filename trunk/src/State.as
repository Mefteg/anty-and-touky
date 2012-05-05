package  
{
	import GameObject.DrawableObject;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import Scene.Library;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class State extends FlxState 
	{
		protected var m_library:Library;
		//used to check if the unique objects have been loaded
		protected var m_uniquesLoaded:Boolean;
		protected var m_state:String ;
		
		public var depthBuffer:DepthBuffer;
		
		public var m_camera:Camera;
		
		public var m_sound:FlxSound;
		
		protected var m_loadProgression:FlxText;
		
		protected var m_dynamicLoadingObject:DrawableObject;
		
		public function State() 
		{
			m_state = "Loading";
		}
		
		override public function create() : void {				
			//create the camera
			m_camera = new Camera(0, 0, 640, 480);
			FlxG.addCamera(m_camera);
		}
		
		override public function update() : void {
			super.update();
			
			switch(m_state) {
				//load images
				case "Loading":
					this.loading();
					break;
				case "LoadingNewBitmap" : 
					this.loadingNewBitmap();
					break;
				default : break;
			}			
		}
		
		protected function loading() : void {
			//display loading advancement
			m_loadProgression.text = m_library.getAdvancement().toString();
			m_loadProgression.text += "\n" + m_library.getCurrentLoaded();
		}
		
		protected function loadingNewBitmap() : void {
			Global.library.loadAll();
			if (Global.library.loadComplete()) {
				m_dynamicLoadingObject.load();
				Global.library.cacheObjects();
				m_state = "Loaded";
			}
		}
	}

}
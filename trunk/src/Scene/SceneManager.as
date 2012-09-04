package Scene 
{
	import com.adobe.serialization.json.JSON;
	import flash.net.URLVariables;
	import GameObject.GameObject;
	import Server.URLRequestPHP;
	
	import org.flixel.FlxExtBitmap;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author ...
	 */
	public class SceneManager 
	{
		//the current scene display
		protected var m_currentScene:Scene.Scene;
		protected var m_previousScene:Scene.Scene;
		
		public var m_state:String;
		
		public var m_music:FlxSound;
		
		public function SceneManager() 
		{
			m_music = new FlxSound;
		}
		
		public function loadScene(sceneName:String,respawn:String=null) : void {
			//if a scene has already been loaded
			if (m_currentScene) {
				//keep the current scene as previous
				m_previousScene = m_currentScene;
				m_currentScene.removeElementsFromStage();
			}
			m_currentScene = new Scene.Scene(sceneName);
			m_currentScene.setRespawn(respawn);
			//create and load images in the library/ create objects in the scene
			m_currentScene.load();
			m_state = "Loading";
		}
		
		//destroy bitmap that are not needed in the new scene
		public function updateLibrary():void {
			var currentLib:Object = m_currentScene.m_library;
			var previousLib:Object = m_previousScene.m_library;
			//for all bitmap in the previous
			for ( var name:String in previousLib) {
				//if they are not in the current one
				if (!currentLib)
					//delete them from the global library
					Global.library.deleteBitmap(name);
			}
		}
		
		public function isLoadComplete():Boolean {
			return (m_state == "Loaded");
		}
		
		public function update():void {
			switch(m_state) {
				//wait for the images in the library to complete their loading
				case "Loading": if ( m_currentScene.isLoadCOmplete()){
									Global.library.loadAll();
									if(Global.library.loadComplete())
										m_state = "Cache";
								}
								break;
				//load images in the cache
				case "Cache" : 	Global.library.cacheObjects();
								if(m_previousScene)
									updateLibrary();
								m_currentScene.loadGraphics();//load Objects
								m_currentScene.spawnPlayers();
								//play music
								if (m_currentScene.m_music && m_currentScene.m_music != m_music.name) {
									chargeMusic(m_currentScene.m_music,true);
								}
								m_state = "Loaded"; 
								break;
				default:break;
			}
						
		}
		
		public function chargeMusic(url:String, loop:Boolean ) : void {
			if (url == "stop") {
				m_music.stop();
				return;
			}
			m_music.loadStream("Music/" + url + ".mp3", loop );
			m_music.name = url ;
			m_music.play();
		}
		
		public function findObjectByType(name:String):GameObject {
			return m_currentScene.findObjectByType(name);
		}
		
		public function findObjectByName(name:String):GameObject {
			return m_currentScene.findObjectByName(name);
		}
		
		public function get currentScene():Scene.Scene 
		{
			return m_currentScene;
		}
		
		public function GetCurrentState():String{
			return m_state;
		}
	}

}
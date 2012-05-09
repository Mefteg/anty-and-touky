package  
{
	import GameObject.Enemy.Enemy;
	import GameObject.MovableObject;
	import GameObject.PhysicalObject;
	import Scene.CollisionManager;
	import Scene.CutScene.CutScene;
	import flash.display.Stage;
	import GameObject.DrawableObject;
	import GameObject.Enemy.Slime;
	import GameObject.Item.Item;
	import GameObject.Magic.Magic;
	import GameObject.Menu.Menu;
	import GameObject.Menu.Message;
	import GameObject.Player.Player1;
	import GameObject.Player.Player2;
	
	import InfoObject.Info;
	import InfoObject.InfoDamage;
	
	import Scene.Library;
	import Scene.Scene;
	import Scene.SceneManager;
	
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Playstate extends State 
	{				
		protected var m_sceneManager:SceneManager;
		
		protected var m_menu_p1:Menu;
		protected var m_menu_p2:Menu;
		
		//arrays for collisions
		public var m_physicalObjects:Vector.<PhysicalObject>;
		public var m_collisionManager:CollisionManager;	
		public var m_talkersObjects:Vector.<MovableObject>;
		public var m_enemies:Vector.<Enemy>;
		
		public function Playstate() 
		{
			m_library = new Library();
			Global.library = m_library;
			m_uniquesLoaded = false;
			Global.currentState = this;
			Global.currentPlaystate = this;
			depthBuffer = new DepthBufferPlaystate();
			add(depthBuffer);
			//text displaying loading advancement
			m_loadProgression = new FlxText(400, 400, 600);
			add(m_loadProgression);
			m_talkersObjects = new Vector.<MovableObject>;
			m_collisionManager = new CollisionManager();
			add(m_collisionManager);
			m_enemies = new Vector.<Enemy>;
		}
		
		public function changeScene(sceneName:String, respawn:String ) : void {
			depthBuffer.clearBuffers();
			m_sceneManager.loadScene(sceneName, respawn);
			m_state = "Loading";
			//prevent players from moving
			Global.player1.block();
			Global.player2.block();
		}
		
		public function loadNewBitmaps(object:DrawableObject):void {
			m_state = "LoadingNewBitmap";
			m_dynamicLoadingObject = object;
		}
		
		override public function create() : void {
			m_sceneManager = new SceneManager();
			m_sceneManager.loadScene("Maps/test.json");
			m_state = "Loading";
			//creating player 1
			Global.player1 = new Player1(100, 100);
			Global.player1.addBitmap();
			Global.player1.addToStage();
			
			m_menu_p1 = new Menu(Global.player1);
			m_menu_p1.addToStage();
			Global.menuPlayer1 = m_menu_p1;

			//creating player2
			Global.player2 = new Player2(100, 110);
			Global.player2.addBitmap();
			Global.player2.addToStage();
						
			m_menu_p2 = new Menu(Global.player2);
			m_menu_p2.m_shift = new FlxPoint(640 - m_menu_p2.m_width, 0);
			m_menu_p2.addToStage();
			Global.menuPlayer2 = m_menu_p2;
			
			
			//create the camera
			m_camera = new Camera(0, 0, 640, 480);
			FlxG.addCamera(m_camera);
			
			//create the message bitmap
			Global.library.addUniqueBitmap("Images/Menu/bulle.png");
		}

		override public function update() : void {
			m_sceneManager.update();
			super.update();
		}
		
		override protected function loading() : void {
			super.loading();
			//if the scene manager has finished the loading
			if (m_sceneManager.isLoadComplete()) {
				//stop displaying advancement
				m_loadProgression.text = "";
				m_state = "Done";
				//check uniques loading
				if(!m_uniquesLoaded){
					Global.player1.load();
					m_menu_p1.load();
					Global.player2.load();
					m_menu_p2.load();
					m_uniquesLoaded = true;
				}
				Global.player1.unblock();
				Global.player2.unblock();
				//m_menu_p2.load();
				Global.player1.getEnemiesInScene();
				Global.player2.getEnemiesInScene();
			}
		}
		
		override protected function loadingNewBitmap() : void  {
			Global.library.loadAll();
			if (Global.library.loadComplete()) {
				m_dynamicLoadingObject.load();
				Global.library.cacheObjects();
				if (m_dynamicLoadingObject.m_typeName == "Magic"){
					var magic:Magic = m_dynamicLoadingObject as Magic;
				}else if (m_dynamicLoadingObject.m_typeName == "Item") {
					var item:Item = m_dynamicLoadingObject as Item;
				}
				m_dynamicLoadingObject = null;
				m_state = "Loaded";
			}
		}
		
		public function chargeMusic(name:String) {
			m_sceneManager.chargeMusic(name);
		}
		
		public function getCurrentScene():Scene 
		{
			return m_sceneManager.currentScene;
		}
		
		public function get sceneManager():SceneManager 
		{
			return m_sceneManager;
		}
		
		public function clearArrays():void {
			clearPhysical();
			clearTalkers();
			clearEnemies();
		}
		//////////PHYSICALS/////////////
		public function addPhysical(object:PhysicalObject):void {
			m_collisionManager.m_physicalObjects.push(object);
		}
		public function removePhysical(object:PhysicalObject):void {
			m_collisionManager.removeObject(object);
		}
		public function clearPhysical():void {
			m_collisionManager.m_physicalObjects = new Vector.<PhysicalObject>;
		}
		//TALKERS
		public function addTalkers(object:MovableObject):void {
			m_talkersObjects.push(object);
		}
		public function removeTalkers(object:MovableObject):void {
			m_talkersObjects.splice(m_talkersObjects.indexOf(object), 1);
		}
		public function clearTalkers():void {
			m_talkersObjects = new Vector.<MovableObject>;
		}
		//ENEMIES
		public function addEnemy(object:Enemy):void {
			m_enemies.push(object);
		}
		public function removeEnemy(object:Enemy):void {
			m_enemies.splice(m_enemies.indexOf(object), 1);
		}
		public function clearEnemies():void {
			m_enemies = new Vector.<Enemy>;
		}
	}

}
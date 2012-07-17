package  
{
	import GameObject.Enemy.Enemy;
	import GameObject.Item.Collectable;
	import GameObject.MovableObject;
	import GameObject.Other.Box;
	import GameObject.Other.BoxHole;
	import GameObject.Other.Door;
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
		
		protected var m_sceneToLoad:String;
		protected var m_respawnToLoad:String;
		
		protected var m_menu_p1:Menu;
		protected var m_menu_p2:Menu;
		
		//arrays for collisions
		public var m_physicalObjects:Vector.<PhysicalObject>;
		public var m_collisionManager:CollisionManager;	
		public var m_talkersObjects:Vector.<MovableObject>;
		public var m_enemies:Vector.<Enemy>;
		public var m_boxes:Vector.<Box>;
		public var m_holeboxes:Vector.<BoxHole>;
		public var m_doors:Vector.<Door>;
		public var m_collectables:Vector.<Collectable>;
		
		private var m_ladyBug:FlxSprite;
		private var m_rectLadyBug:FlxSprite;
		private var m_initPosRect:Number;
		
		
		//buttons
		public var m_enablePanels:Boolean = true;
		protected var m_pauseButton:FlxButton;
		protected var m_controlButton:FlxButton;
		protected var m_controlsPanel:FlxSprite;
		protected var m_controlShown:Boolean = false;
		
		//texts
		protected var m_textLife1:FlxText;
		protected var m_textLife2:FlxText;
		protected var m_textScore1:FlxText;
		protected var m_textScore2:FlxText;
		
		private var m_timerEnd:FlxTimer;
		private var m_goSwitch:Boolean = false;
		
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
			//add(m_loadProgression);
			m_talkersObjects = new Vector.<MovableObject>;
			m_physicalObjects = new Vector.<PhysicalObject>;
			m_collisionManager = new CollisionManager();
			m_boxes = new Vector.<Box>();
			m_holeboxes = new Vector.<BoxHole>();
			m_doors = new Vector.<Door>();
			m_collectables = new Vector.<Collectable>();
			add(m_collisionManager);
			m_enemies = new Vector.<Enemy>;
			//lady Bug for loading screens
			m_ladyBug = new FlxSprite(FlxG.width - 60 , FlxG.height - 60);
			m_ladyBug.loadGraphic(LadyBug, false, false, 32, 32, true);
			m_rectLadyBug = new FlxSprite(m_ladyBug.x, m_ladyBug.y);
			m_rectLadyBug.makeGraphic(32, 32,FlxG.bgColor);
			m_initPosRect = m_rectLadyBug.y;
			//PAUSE BUTTON
			m_pauseButton = new FlxButton(600, 460, "",pause);
			m_library.addUniqueBitmap("Images/Menu/pauseButton.png");
			m_pauseButton.scrollFactor = new FlxPoint(0, 0);
			depthBuffer.addElement(m_pauseButton, DepthBuffer.s_menuGroup );
			//TOOL BUTTON
			m_controlButton = new FlxButton(620, 460, "",showControls);
			m_library.addUniqueBitmap("Images/Menu/toolButton.png");
			m_controlButton.scrollFactor = new FlxPoint(0, 0);
			depthBuffer.addElement(m_controlButton, DepthBuffer.s_menuGroup );
			//loading control panel
			m_controlsPanel = new FlxSprite(0, 0);
			m_controlsPanel.scrollFactor = new FlxPoint(0, 0);
			m_library.addUniqueBitmap("Images/Menu/controlpanel.png");
			FlxG.mouse.show();
			m_timerEnd = new FlxTimer();
			
			//text lifes
			m_textLife1 = new FlxText(96, 25, 40);
			m_textLife1.size = 12;
			m_textLife1.scrollFactor = new FlxPoint(0, 0);
			m_textLife1.color = 0x000000;
			depthBuffer.addElement(m_textLife1, DepthBuffer.s_cursorGroup);
			
			m_textLife2 = new FlxText(616, 25, 40);
			m_textLife2.size = 12;
			m_textLife2.scrollFactor = new FlxPoint(0, 0);
			m_textLife2.color = 0x000000;
			depthBuffer.addElement(m_textLife2, DepthBuffer.s_cursorGroup);
			
			//text scores
			m_textScore1 = new FlxText(20, 47,100);
			m_textScore1.size = 12;
			m_textScore1.scrollFactor = new FlxPoint(0, 0);
			m_textScore1.alignment = "right";
			//m_textScore1.color = 0x000000;
			depthBuffer.addElement(m_textScore1, DepthBuffer.s_cursorGroup);
			
			m_textScore2 = new FlxText(625, 47,100);
			m_textScore2.size = 12;
			m_textScore2.scrollFactor = new FlxPoint(0, 0);
			m_textScore1.alignment = "right";
			//m_textScore2.color = 0x000000;
			if(Global.nbPlayers == 2)
				depthBuffer.addElement(m_textScore2, DepthBuffer.s_cursorGroup);
		}
		
		public function changeScene(sceneName:String, respawn:String ) : void {
			fadeOut();
			m_sceneToLoad = sceneName;
			m_respawnToLoad = respawn;
			clearCollectables();
			Global.frozen = true;
			m_state = "ChangingScene";
		}
		
		public function loadNewBitmaps(object:DrawableObject):void {
			m_state = "LoadingNewBitmap";
			m_dynamicLoadingObject = object;
		}
		
		override public function create() : void {
			super.create();
			depthBuffer.addElement(m_ladyBug, DepthBuffer.s_cursorGroup);
			depthBuffer.addElement(m_rectLadyBug, DepthBuffer.s_cursorGroup);
			m_sceneManager = new SceneManager();
			m_sceneManager.loadScene("Maps/W1M1.json");
			//m_sceneManager.loadScene("Maps/test2.json");
			//m_sceneManager.loadScene("Maps/W1M3.json");
			m_state = "Loading";
			//creating player 1
			Global.player1 = new Player1(100, 100);
			Global.player1.addBitmap();
			Global.player1.addToStage();
			
			m_menu_p1 = new Menu(Global.player1);
			m_menu_p1.addToStage();
			Global.menuPlayer1 = m_menu_p1;
			Global.player1.m_menu = Global.menuPlayer1;
			//creating player2
			Global.player2 = new Player2(100, 110);
			Global.player2.addBitmap();
			Global.player2.addToStage();	
			m_menu_p2 = new Menu(Global.player2);
			m_menu_p2.m_shift = new FlxPoint(640 - m_menu_p2.m_width, 0);
			m_menu_p2.addToStage();
			Global.menuPlayer2 = m_menu_p2;
			Global.player2.m_menu = Global.menuPlayer2;
			if (Global.nbPlayers == 1) {
				//the soloplayer by default is the first one
				Global.soloPlayer = Global.player1;
			}
						
			//create the camera
			m_camera = new Camera(0, 0, 640, 480);
			Global.camera = m_camera;
			FlxG.addCamera(m_camera);
			Global.camera = m_camera;
			//create the message bitmap
			Global.library.addUniqueBitmap("Images/Menu/bulle.png");
		}

		override public function update() : void {
			m_sceneManager.update();
			checkingControlPanel();
			changePlayer();
			m_textLife1.text = "x" + Global.player1.m_lifes;
			m_textLife2.text = "x" + Global.player2.m_lifes;
			m_textScore1.text = ""+Global.player1.m_score;
			m_textScore2.text = ""+Global.player2.m_score;
			super.update();
		}
		
		override protected function loading() : void {
			super.loading();
			
			//moving the rectangle that hides the ladybug
			var h:int = 32 * (1 - m_library.getAdvancement() / 100) ;
			if(h!=0)
				m_rectLadyBug.y = m_initPosRect - ( m_rectLadyBug.height - h);
			//if the scene manager has finished the loading
			if (m_sceneManager.isLoadComplete()) {
				//stop displaying advancement
				m_loadProgression.text = "";
				m_state = "Done";
				fadeIn();
				depthBuffer.removeElement(m_ladyBug, DepthBuffer.s_cursorGroup);
				depthBuffer.removeElement(m_rectLadyBug, DepthBuffer.s_cursorGroup);
				//check uniques loading
				if(!m_uniquesLoaded){
					Global.player1.load();
					m_menu_p1.load();
					Global.player2.load();
					m_menu_p2.load();
					m_controlsPanel.loadGraphic2(m_library.getBitmap("Images/Menu/controlpanel.png"));
					m_pauseButton.loadGraphic2(m_library.getBitmap("Images/Menu/pauseButton.png"), false, false, 16, 16);
					m_controlButton.loadGraphic2(m_library.getBitmap("Images/Menu/toolButton.png"), false, false, 16, 16);
					m_uniquesLoaded = true;
				}
				Global.frozen = false;
				//m_menu_p2.load();
				Global.player1.getEnemiesInScene();
				Global.player2.getEnemiesInScene();
				if (!Global.hasSeenControls) {
					Global.hasSeenControls = true;
					showControls();
				}
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
		
		override protected function changingScene():void {
			if (m_fadeOut)
				return;
			
			depthBuffer.clearBuffers();
			depthBuffer.addElement(m_ladyBug, DepthBuffer.s_cursorGroup);
			depthBuffer.addElement(m_rectLadyBug, DepthBuffer.s_cursorGroup);
			m_sceneManager.loadScene(m_sceneToLoad, m_respawnToLoad);
			
			m_state = "Loading";
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
		
		public function showControls():void {
			depthBuffer.addElement(m_controlsPanel, DepthBuffer.s_cursorGroup);
			Global.frozen = true;
			m_controlShown = true;
		}
		
		public function checkingControlPanel():void {
			if (m_enablePanels && ( FlxG.keys.justPressed("ESCAPE") || FlxG.keys.justPressed("ENTER") ) ) {
				if(m_controlShown){
					depthBuffer.removeElement(m_controlsPanel, DepthBuffer.s_cursorGroup);
					Global.frozen = false;
					m_controlShown = false;
				}else {
					showControls();
				}
			}
		}
		
		public function pause():void {
			if(Global.frozen){
				Global.frozen = false;
				m_screenFade.alpha = 0.0;
			}else {
				Global.frozen = true;
				m_screenFade.alpha = 0.5;
			}
		}
		
		override public function end():void {
			m_state = "Ending";
			Global.frozen = true;
			m_timerEnd.start(3);
		}
		
		override protected function ending():void {
			if (m_goSwitch && !m_fadeOut) {
				m_sceneManager = null;
				Global.player1.x = Global.player2.x = 320;
				Global.player1.y = Global.player2.y = 240;
				depthBuffer.clearBuffers();
				Global.camera = null;
				FlxG.switchState(new Menustate());
				return;
			}
			if (m_timerEnd.finished) {
				fadeOut();
				m_goSwitch = true;
			}
		}
		
		public function changePlayer():void {
			if ( ! Global.soloPlayer) 
				return;
			if ( ! FlxG.keys.justPressed("SPACE") )
				return;
			if (Global.soloPlayer.m_state == "respawn")
				return;
			if (Global.soloPlayer.m_name == Global.player1.m_name){
				Global.soloPlayer = Global.player2;
				Global.soloPlayer.visible = true;
				Global.soloPlayer.m_camembert.visible = true;
				Global.player1.visible = false;
				Global.player1.m_camembert.visible = false;
			}else {
				Global.soloPlayer = Global.player1;
				Global.soloPlayer.visible = true;
				Global.player2.visible = false;
				Global.soloPlayer.m_camembert.visible = true;
				Global.player2.m_camembert.visible = false;
			}
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
		//BOXES
		public function addBox(object:Box):void {
			m_boxes.push(object);
		}
		public function removeBox(object:Box):void {
			m_boxes.splice(m_boxes.indexOf(object), 1);
		}
		public function clearBoxes():void {
			m_enemies = new Vector.<Enemy>;
		}
		//HOLEBOXES
		public function addHoleBox(object:BoxHole):void {
			m_holeboxes.push(object);
		}
		public function removeHoleBox(object:BoxHole):void {
			m_holeboxes.splice(m_holeboxes.indexOf(object), 1);
		}
		public function clearHoleBoxes():void {
			m_holeboxes = new Vector.<BoxHole>;
		}
		//DOORS
		public function addDoor(object:Door):void {
			m_doors.push(object);
		}
		public function removeDoor(object:Door):void {
			m_doors.splice(m_doors.indexOf(object), 1);
		}
		public function clearDoors():void {
			m_doors = new Vector.<Door>;
		}
		public function getDoor(door:String):Door {
			for (var i:int = 0; i < m_doors.length; i++) {
				if (m_doors[i].m_name == door)
					return m_doors[i];
			}
			return null;
		}
		//COLLECTABLES
		public function addCollectable(object:Collectable):void {
			m_collectables.push(object);
		}
		public function removeCollectable(object:Collectable):void {
			m_collectables.splice(m_collectables.indexOf(object), 1);
		}
		public function clearCollectables():void {
			for (var i:int = 0; i < m_collectables.length; i++)
				m_collectables[i].removeFromStage();
			m_collectables = new Vector.<Collectable>;
		}
	}

}
package Scene.CutScene 
{
	import flash.display.GraphicsStroke;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import GameObject.GameObject;
	import GameObject.Menu.Message;
	import GameObject.MovableObject;
	import org.flixel.FlxBasic;
	/**
	 * ...
	 * @author ...
	 */
	public class CutScene extends FlxBasic
	{
		public var m_xml:XML;
		
		private var m_state:String;
		private var m_currentActionGroup:int;
		private var m_nbActionGroup:int;
		private var m_currentActors:Vector.<CutSceneObject>;	
		private var m_currentMessage:Message;
		
		private var m_currentActor:int;
		private var m_allFinished:Boolean;
		
		private var m_talkers:Vector.<MovableObject>;
		
		public function CutScene(scriptUrl:String="") 
		{
			m_currentActionGroup = 0;
			loadXML(scriptUrl+".xml");
		}
		
		
		/**************************************************************/
		//////////////////// XML LOADING///////////////////////////////
		private function loadXML(url:String):void 
		{
			var request:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(request);
		}
		
		private function onComplete(e:Event):void
		{
			m_xml = new XML(e.target.data);
			m_nbActionGroup = m_xml.actiongroup.length();
		}
		/***************************************************************/
		
		public function start():void {
			Global.currentState.add(this);
			Global.frozen = true;
			Global.currentPlaystate.m_enablePanels = false;
			m_talkers = Global.currentPlaystate.m_talkersObjects;
			next();
		}
		
		public function end():void {
			Global.currentPlaystate.m_enablePanels = true;
			Global.frozen = false;
			trace(m_talkers.length);
			for (var i:int = 0; i < m_talkers.length ; i++) 
				m_talkers[i].unblock();
			Global.currentState.remove(this);
		}
		
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
		//!!!!!!!!!!!!!!!! INSTRUCTIONS!!!!!!!!!!!!!!!!!!!!!!!!//		
		public function message(object:GameObject,text:String):void {
			m_currentMessage = new Message(text, object);
		}
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
		
		//ACTOR CREATION FUNCTIONS
		private function createActors():void {
			//trace("CreateActors for action group ",m_currentActionGroup);
			m_currentActors = new Vector.<CutSceneObject>();
			var actionGroup:XML = m_xml.actiongroup[m_currentActionGroup];
			
			for each(var act:XML in actionGroup..action) {
				switch(act.@type.toString()) {
					case "move" : createMover(act); break;
					case "message": createTalker(act); break;
					case "music" : m_currentActors.push(new CutSceneMusicObject(act.@name.toString())); break;
					default: m_nbActionGroup--; trace("Failed : ",act.@type.toString()); break;
				}
			}
					
		}
		
		private function createMover(actionXML:XML) : void {
			var executor:MovableObject
			switch(actionXML.@executor.toString()) {
				case "Player1" : executor = Global.player1; break;
				case "Player2" : executor = Global.player2; break;
				default : 
			}
			var tx:Number = actionXML.@targetX;
			var ty:Number = actionXML.@targetY;
			m_currentActors.push(new CutSceneMovableObject(executor, new GameObject(tx, ty)));
			//trace(executor.m_typeName,tx,ty)
		}
		
		private function createTalker(actionXML:XML) : void {
			var executor:MovableObject
			switch(actionXML.@executor.toString()) {
				case "Player1" : executor = Global.player1; break;
				case "Player2" : executor = Global.player2; break;
				default : executor = findTalker(actionXML.@executor.toString());
			}
			var msg:String = actionXML.@text;
			m_currentActors.push(new CutSceneMessageObject(executor,m_currentMessage,msg));
			//trace(executor.m_typeName,msg)
		}
		
		private function findTalker(name:String) : GameObject.MovableObject {
			for (var i:int = 0; i < m_talkers.length ; i++) {
				if (m_talkers[i].m_name == name) {
					return m_talkers[i];
				}
			}
			return null;
		}
		
		public function next():void {
			//if the scene is over
			if (m_currentActionGroup >= m_nbActionGroup) {
				end();
				return;				
			}
			//check if it has to be played as Synchronized or not
			switch(m_xml.actiongroup[m_currentActionGroup].@sync.toString()) {
				case "1" : m_state = "Sync"; m_currentActor = 0; break;
				case "0" : m_state = "ASync"; break;
				default : trace("Failed To Get Node Type"); break;
			}
			//create the actors for this part of the scene
			createActors();
			//prepare next action
			m_currentActionGroup ++;
		}
		
		override public function update():void {
			switch(m_state){
				case "ASync": m_allFinished = true;
								for (var i:int = 0; i < m_currentActors.length; i++) {
									m_currentActors[i].act();
									m_allFinished = m_allFinished && m_currentActors[i].isFinished();
								}
								if (m_allFinished)
									next();
								break;
				case "Sync": m_currentActors[m_currentActor].act();
							if (m_currentActors[m_currentActor].isFinished()) {
								m_currentActor ++;
								if (m_currentActor >= m_currentActors.length)
									next();
							}
				default : break;
			}
		}
		
	}

}
package GameObject.Other 
{
	import flash.events.Event;
	import flash.filters.ConvolutionFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import GameObject.InteractiveObject;
	import GameObject.Menu.Message;
	import GameObject.PhysicalObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxG;
	import Scene.CutScene.CutSceneMessageObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NPC extends InteractiveObject 
	{
		private var m_messages:Array;
		private var m_currentMessageID:int = 0;
		private var m_currentMessage:Message;
		private var m_currentPlayer:PlayableObject;
		private var m_nbMessage:int = 0;
		
		public function NPC(X:Number, Y:Number,urlXml:String) 
		{
			super(X, Y);
			m_state = "idle";
			loadXML("Dialogues/" + urlXml + ".xml");
		}
		
		private function speak(player:PlayableObject ):void {
			Global.frozen = true;
			m_currentPlayer = player;
			facing = getFacingToTarget(m_currentPlayer);
			play(facing.toString());
			m_state = "speaking";
			m_currentMessage = new Message(m_messages[m_currentMessageID].toString() , this, m_currentPlayer);
		}
		
		override public function update() : void {
			if (m_hasToFreePlayers)
				freePlayers();	
				
			if (m_state == "speaking") {
				if (m_currentMessage.isFinished()) {
					m_currentMessageID++;
					//si tous les messages sont finis
					if (m_currentMessageID >= m_nbMessage) {
						m_currentMessageID = 0;
						m_currentMessage = null;
						Global.frozen = false;
						m_state = "idle";
					}else {
						m_currentMessage = new Message(m_messages[m_currentMessageID].toString() , this, m_currentPlayer);
					}
				}
				return;
			}
			//check Player 1
			if (canInteract(Global.player1)) {
				if(FlxG.keys.justPressed(Global.player1.getButtonValidate())){
					speak(Global.player1);
				}	
			}
			//check Player 2
			if(canInteract(Global.player2)){
				if(FlxG.keys.justPressed(Global.player2.getButtonValidate())){
					speak(Global.player2);
				}	
			}
		}
		
		/////////////// OVERRIDES /////////////////////:
		override public function load():void {
			super.load();
			addAnimation(DOWN.toString(), [0]);
			addAnimation(UP.toString(), [1]);
			addAnimation(RIGHT.toString(), [2]);
			addAnimation(LEFT.toString(), [3]);
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.addPhysical(this as PhysicalObject);
			Global.currentPlaystate.addTalkers(this);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_objectGroup);
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
			m_messages = new Array();
			var xml:XML = new XML(e.target.data);
			for each(var msg:XML in xml..message) {
				m_nbMessage++;
				m_messages.push(msg.@text.toString());
			}
		}
		/***************************************************************/
		
		////////////// PREBUILDED NPCs ////////////////////
		public static function Raccoon(X:Number, Y:Number,url:String) {
			var raccoon:NPC = new NPC(X, Y,url);
			raccoon.m_url = "Images/NPC/racoon.png";
			raccoon.m_width = 48; raccoon.m_height = 48;
			raccoon.setHitbox(5, 5, 35, 35);
			return raccoon;
		}
		
		public static function MexicanRaccoon(X:Number, Y:Number,url:String) {
			var raccoon:NPC = new NPC(X, Y,url);
			raccoon.m_url = "Images/NPC/racoon_mexican.png";
			raccoon.m_width = 48; raccoon.m_height = 48;
			raccoon.setHitbox(5, 5, 35, 35);
			return raccoon;
		}
		
	}

}
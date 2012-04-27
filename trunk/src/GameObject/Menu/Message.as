package GameObject.Menu 
{
	import GameObject.DrawableObject;
	import GameObject.GameObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxG;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author ...
	 */
	public class Message extends DrawableObject
	{
		//text to display
		public var m_text:String;
		//text currently displayed
		public var m_currentText:String;
		//object FLxText
		public var m_objectText:FlxText;
		//target
		public var m_target:GameObject;
		
		public var m_player:GameObject.PlayableObject;
		
		public var m_index:int;
				
		public function Message( text:String,object:GameObject,player:PlayableObject= null ,width:int=130, height:int=75 ) 
		{
			super(0, 0);
			m_url = "Images/Menu/bulle.png";
			if (player == null)
				m_player = Global.player1;
			else
				m_player = player;
			m_objectText = new FlxText(0, 0, width);
			m_objectText.size = 10;
			m_width = width;
			m_height = height;
			m_target = object;
			addToStage();
			load();
			displayMessage(text);
		}
		
		override public function addToStage() : void {
			Global.currentState.depthBuffer.addMenu(this);
			Global.currentState.depthBuffer.addMenu(m_objectText);
		}
		
		public function displayMessage(msg:String) :void {
			m_text = msg;
			m_index = 0;
			m_currentText = "";
			m_state = "writing";
		}
		
		public function end():void {
			Global.currentState.depthBuffer.removeMenu(this);
			Global.currentState.depthBuffer.removeMenu(m_objectText);
			m_state = "ended";
		}
		
		public function isFinished():Boolean {
			return m_state == "ended";
		}
		
		override public function load() : void{
			loadGraphic2(Global.library.getBitmap(m_url), true, false, m_width, m_height);
		}
		
		override public function update():void {
			super.update();
			//place the sprite
			x = m_target.x-m_width/2; y = m_target.y-m_height;
			//place the text
			m_objectText.x = x + 1;
			m_objectText.y = y + 1;
			switch(m_state) {
				case "writing": write();
								if (playerPassed()){
									m_objectText.text = m_text;
									m_state = "ready";
								}
								break;
				case "ready": if (playerPassed())
								end();
							break;
				default : break;
			}
		}
		
		private function playerPassed():Boolean {
			if (FlxG.keys.justPressed(m_player.getButtonValidate()))
				return true;
			return false;
		}
		
		private function write():void {
			m_currentText += m_text.charAt(m_index);
			m_objectText.text = m_currentText;
			m_index++;
			if (m_index >= m_text.length)
				m_state = "ready";
		}
	}

}
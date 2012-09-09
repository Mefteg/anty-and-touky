package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxInputText;
	import org.flixel.FlxPoint;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author ...
	 */
	public class PasswordManager extends FlxBasic
	{
		public var m_name:String;
		public var m_position:FlxPoint;
		public var m_size:FlxPoint;
		
		public var m_backgroundOnOver:uint;
		public var m_backgroundOnOut:uint;
		public var m_textOnOver:uint;
		public var m_textOnOut:uint;
		public var m_fontSize:uint;
		public var m_paddingY:int;
		public var m_text:String;
		
		protected var m_textField:FlxInputText;
		protected var m_textInfo:FlxText;
		
		public function PasswordManager(infos:Array) 
		{
			m_position = infos["position"];
			m_size = infos["size"];
			m_name = infos["name"];
			m_backgroundOnOver = infos["backgroundOnOver"];
			m_backgroundOnOut = infos["backgroundOnOut"];
			m_textOnOver = infos["textOnOver"];
			m_textOnOut = infos["textOnOut"];
			m_fontSize = infos["fontSize"];
			m_paddingY = infos["textPaddingY"];
			
			m_text = infos["label"];
			
			m_textField = new FlxInputText(m_position.x, m_position.y, m_size.x, m_size.y, m_text);
			//m_textField.size = 13;
			m_textField.size = m_fontSize;
			m_textField.filterMode=FlxInputText.ONLY_ALPHANUMERIC;
			m_textInfo = new FlxText(m_size.x, m_size.y, 200);
			m_textInfo.size = m_fontSize;
			m_textInfo.color = 0;
			
			Global.password = m_text;
			
			Global.currentState.depthBuffer.addElement(m_textInfo, DepthBuffer.s_menuGroup);
			Global.currentState.depthBuffer.addElement(m_textField, DepthBuffer.s_menuGroup);
			Global.currentState.depthBuffer.addElement(this, DepthBuffer.s_menuGroup);
		}
		
				
		override public function update():void {
			Global.password = m_textField.text;
			/*if (FlxG.keys.justPressed("ENTER"))
			{
				PasswordManager.UsePassword(Global.password);
				//m_textInfo.text = PasswordManager.UsePassword(Global.password);
				//m_textField.text = PasswordManager.UsePassword(Global.password);
			}*/
		}
		
		override public function destroy() : void {
			Global.currentState.depthBuffer.removeElement(m_textInfo, DepthBuffer.s_menuGroup);
			Global.currentState.depthBuffer.removeElement(m_textField, DepthBuffer.s_menuGroup);
			m_textField.destroy();
			Global.currentState.depthBuffer.removeElement(this, DepthBuffer.s_menuGroup);
		}
		
		public static function UsePassword(password:String):String {
			var res:String = "Wrong Password";
			switch(password) {
				//SPECIAL POWERS
				case "InYourFace" :
					Global.superUnlimited = true;
					res = "Super Shot Unlimited !!"; break;
				case "Possessed":
					Global.specialUnlimited = true;
					res = "Specials Unlimited (almost)!"; break;
				//LEVEL CHANGIN
				case "Metal":
					Global.firstLevel = "Maps/W3M1.json"; 
					res = "Begin from the last level ! "; break;
				//MUSICS
				case "Music1": 
					Global.currentState.chargeMusic("JungleRumble");
					res = "Music : Jungle Rumble"; break;
				case "Music2": 
					Global.currentState.chargeMusic("wrath of the coconuts");
					res = "Music : Wrath of the coconuts"; break;
				case "Music3": 
					Global.currentState.chargeMusic("MakeTheEggsFly");
					res = "Music : Make the Eggs Fly !"; break;
				case "Music4": 
					Global.currentState.chargeMusic("EvilMachinery");
					res = "Music : Evil Machinery"; break;
				case "Music5": 
					Global.currentState.chargeMusic("RoughClimb");
					res = "Music : Rough Climb"; break;
				case "Music6": 
					Global.currentState.chargeMusic("Menu");
					res = "Music : Menu"; break;
				case "Music7": 
					Global.currentState.chargeMusic("TwoBuddies");
					res = "Music : Two Buddies"; break;
				case "Music8": 
					Global.currentState.chargeMusic("Credits");
					res = "Music : Credits"; break;	
				default : break;
			}
			return res;
		}
	}

}
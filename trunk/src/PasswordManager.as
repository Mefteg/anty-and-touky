package  
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxInputText;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author ...
	 */
	public class PasswordManager extends FlxBasic
	{
		protected var m_textField:FlxInputText;
		protected var m_textInfo:FlxText;
		
		public function PasswordManager() 
		{
			super();
			m_textField = new FlxInputText(FlxG.width-180, FlxG.height - 40, 200, 30, "Your password here !");
			m_textField.size = 13;
			m_textField.filterMode=FlxInputText.ONLY_ALPHANUMERIC;
			m_textInfo = new FlxText(m_textField.x , m_textField.y - 30 , 200);
			m_textInfo.size = 9;
			Global.currentState.add(m_textInfo);
			Global.currentState.add(m_textField);
		}
		
		public function usePassword(password:String):String {
			var res:String = "";
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
					
				default : break;
			}
			return res;
		}
		
		override public function update():void {
			if (FlxG.keys.justPressed("ENTER")){
				m_textInfo.text = usePassword(m_textField.text);
				m_textField.text = "";
			}
		}
	}

}
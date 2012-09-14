package GameObject.Menu 
{
	import GameObject.GameObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author ...
	 */
	public class Indication extends GameObject
	{
		private var indic:FlxText;
		
		public function Indication(X:Number,Y:Number,type:String) 
		{
			indic = new FlxText(X, Y, 500);
			indic.size = 14;
			indic.alpha = 0.7;
			
			if (Global.nbPlayers == 1)
				setText1P(type);
			else
				setText2P(type);
		}
		
		
		private function setText1P(type:String):void {
			switch(type) {
				case "shoot" : indic.text = "K : Shoot / Talk to Raccoons ; "; break;
				case "switch" : indic.text = "SPACE : Switch Player"; break;
				case "walk" : indic.text = " ZQSD / WASD : Move "; break;
				case "deflect" : indic.text = " L : deflect"; break;
				case "rush" : indic.text = "M with Anty : Rush"; break;
				case "take": indic.text = "M with Touky : Take / Release"; break;
			}
		}
		
		private function setText2P(type:String):void {
			switch(type) {
				case "shoot" : indic.text = "SHOOT / Talk to Raccoons : \n Player1 : F   |   Player 2 : K "; break;
				case "switch" : indic.text = ""; break;
				case "walk" : indic.text = "       MOVE : \n Player1 : ZQSD / WASD    |    Player 2 : Arrows"; break;
				case "deflect" : indic.text = "Deflect : \n Player1 : G   |   Player 2 : L \n    "; break;
				case "rush" : indic.text = "RUSH : \n Player1, H on Player2";break;
				case "take": indic.text = "Take / Release :\n Player2, M on Touky or Object "; indic.y -= 10; break;
			}
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.depthBuffer.addElement(indic, DepthBufferPlaystate.s_enemiesFG);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.depthBuffer.removeElement(indic, DepthBufferPlaystate.s_enemiesFG);
		}
		
		
	}

}
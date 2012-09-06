package GameObject.Menu 
{
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author ...
	 */
	public class Controler 
	{
		protected var m_model:Model;
		protected var m_view:View;
		
		public function Controler() {
			
		}
		
		public function onOver(button:MyButton) : void {
			var action:String = button.m_name;
			switch ( action ) {
				default:
					this.onOverButton(button);
					break;
			}
		}
		
		public function onOut(button:MyButton) : void {
			var action:String = button.m_name;
			switch ( action ) {
				case "printDifficulty":
					this.onOutPrintDifficulty(button);
					break;
				default:
					this.onOutButton(button);
					break;
			}
		}
		
		public function onClick(button:MyButton) : void {
			var action:String = button.m_name;
			switch ( action ) {
				case "start1p":
					this.onClickStart1P(button);
					break;
				case "start2p":
					this.onClickStart2P(button);
					break;
				case "options":
					this.onClickOptions(button);
					break;
				case "difficultyDown":
					this.onClickDifficultyDown(button);
					break;
				case "difficultyUp":
					this.onClickDifficultyUp(button);
					break;
				case "credits":
					this.onClickCredits(button);
					break;
				case "backToMenu":
					this.onClickBackToMenu(button);
					break;
				case "tryAgain":
					this.onClickTryAgain(button);
					break;
				case "backToMenuState":
					this.onClickBackToMenuState(button);
					break;
				default:
					this.onClickButton(button);
					break;
			}
		}
		
		public function updatePrint() : void {
			m_view.clear();
			m_view.print();
		}
		
		public function setModel(model:Model) : void {
			m_model = model;
		}
		
		public function setView(view:View) : void {
			m_view = view;
		}
		
		/////////////
		// ACTIONS //
		/////////////
		
		//// ONOVER ////
		
		protected function onOverButton(button:MyButton) : void {
			m_view.changeToColorOver(button);
		}
		
		//// ONOUT ////
		
		protected function onOutButton(button:MyButton) : void {
			m_view.changeToColorOut(button);
		}
		
		protected function onOutPrintDifficulty(button:MyButton) : void {
			m_view.changeToColorOut(button);
			switch ( Global.difficulty )
			{
				case 1:
					button.m_text = "Medium";
					break;
				case 2:
					button.m_text = "Hardcore";
					break;
				case 3:
					button.m_text = "Possessed";
					break;
				default:
					break;
			}
		}
		
		//// ONCLICK ////
		
		protected function onClickButton(button:MyButton) : void {
			trace("CLICKBUTTON");
		}
		
		protected function onClickStart1P(button:MyButton) : void {
			Global.nbPlayers = 1;
			Global.currentState.m_state = "Ending";
		}
		
		protected function onClickStart2P(button:MyButton) : void {
			Global.nbPlayers = 2;
			Global.currentState.m_state = "Ending";
		}
		
		protected function onClickOptions(button:MyButton) : void {
			m_model.clearInfos();
			m_view.clear();
			m_model.loadUrl("Menu/options.xml");
		}
		
		protected function onClickDifficultyDown(button:MyButton) : void {
			Global.difficulty--;
			if ( Global.difficulty < 1 ) {
				Global.difficulty = 1;
			}
		}
		
		protected function onClickDifficultyUp(button:MyButton) : void {
			Global.difficulty++;
			if ( Global.difficulty > 3 ) {
				Global.difficulty = 3;
			}
		}
		
		protected function onClickCredits(button:MyButton) : void {
			m_model.clearInfos();
			m_view.clear();
			m_model.loadUrl("Menu/credits.xml");
		}
		
		protected function onClickBackToMenu(button:MyButton) : void {
			m_model.clearInfos();
			m_view.clear();
			m_model.loadUrl("Menu/menustate.xml");
		}
		
		protected function onClickTryAgain(button:MyButton) : void {
			FlxG.switchState(new Playstate());
		}
		
		protected function onClickBackToMenuState(button:MyButton) : void {
			FlxG.switchState(new Menustate());
		}
	}

}
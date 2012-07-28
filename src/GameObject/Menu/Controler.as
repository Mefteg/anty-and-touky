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
		
		protected function onOverButton(button:MyButton) : void {
			m_view.changeToColorOver(button);
		}
		
		protected function onOutButton(button:MyButton) : void {
			m_view.changeToColorOut(button);
		}
		
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
		}
	}

}
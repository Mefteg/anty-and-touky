package GameObject.Menu 
{
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
		
		public function updatePrint() : void {
			m_view.clear();
			m_view.print();
		}
		
		public function mouseIsOver() : void {
			m_view.changeBackgroundColor();
		}
		
		public function setModel(model:Model) : void {
			m_model = model;
		}
		
		public function setView(view:View) : void {
			m_view = view;
		}
	}

}
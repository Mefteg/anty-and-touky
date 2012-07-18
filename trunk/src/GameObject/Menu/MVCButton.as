package GameObject.Menu 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class MVCButton extends FlxBasic
	{
		protected var m_model:Model;
		protected var m_view:View;
		protected var m_controler:Controler;
		
		public function MVCButton() 
		{
			m_model = new Model(new FlxPoint(), new FlxPoint(100, 50), "test");
			m_view = new View();
			m_controler = new Controler();
			
			m_model.setView(m_view);
			m_view.setModel(m_model);
			m_view.setControler(m_controler);
			m_controler.setModel(m_model);
			m_controler.setView(m_view);
			
			Global.currentState.depthBuffer.addElement(m_view, DepthBuffer.s_menuGroup);
			
			m_controler.updatePrint();
		}
		
	}

}
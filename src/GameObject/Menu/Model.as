package GameObject.Menu 
{
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class Model 
	{
		protected var m_view:View;
		
		protected var m_position:FlxPoint;
		protected var m_size:FlxPoint;
		
		protected var m_function:String;
		
		public function Model(position:FlxPoint, size:FlxPoint, func:String) {
			m_position = position;
			m_size = size;
			m_function = func;
		}
		
		public function setView(view:View) : void {
			m_view = view;
		}
		
		public function getPosition() : FlxPoint {
			return m_position;
		}
		
		public function getSize() : FlxPoint {
			return m_size;
		}
	}

}
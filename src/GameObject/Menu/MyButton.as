package GameObject.Menu 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MyButton extends FlxButton 
	{
		public var m_name:String;
		
		public function MyButton(pos:FlxPoint, size:FlxPoint, name:String, label:String=null, OnClick:Function=null) 
		{
			super(pos.x, pos.y, label, OnClick);
			m_name = name;
			if ( m_name == "" ) {
				m_name = "button";
			}
		}
		
	}

}
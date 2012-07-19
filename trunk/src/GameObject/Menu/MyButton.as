package GameObject.Menu 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MyButton 
	{
		public var m_name:String;
		public var m_position:FlxPoint;
		public var m_size:FlxPoint;
		
		protected var m_background:FlxSprite;
		protected var m_label:FlxText;
		
		public function MyButton(pos:FlxPoint, size:FlxPoint, name:String, label:String=null) 
		{
			m_name = name;
			m_position = pos;
			m_size = size;
			if ( m_name == "" ) {
				m_name = "button";
			}
			
			m_background = new FlxSprite(pos.x, pos.y);
			m_background.makeGraphic(size.x, size.y);
			m_label = new FlxText(pos.x, pos.y, size.x, label);
			m_label.color = FlxG.PINK;
			
			Global.currentState.depthBuffer.addElement(m_background, DepthBuffer.s_menuGroup);
			Global.currentState.depthBuffer.addElement(m_label, DepthBuffer.s_menuGroup);
		}
		
		public function changeBackgroundColor(_color:uint) : void {
			m_background.makeGraphic(m_size.x, m_size.y, _color);
		}
		
	}

}
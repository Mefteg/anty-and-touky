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
		
		public var m_backgroundOnOver:uint;
		public var m_backgroundOnOut:uint;
		public var m_textOnOver:uint;
		public var m_textOnOut:uint;
		
		protected var m_background:FlxSprite;
		protected var m_label:FlxText;
		
		public function MyButton(infos:Array) 
		{
			m_position = infos["position"];
			m_size = infos["size"];
			m_name = infos["name"];
			m_backgroundOnOver = infos["backgroundOnOver"];
			m_backgroundOnOut = infos["backgroundOnOut"];
			m_textOnOver = infos["textOnOver"];
			m_textOnOut = infos["textOnOut"];
			
			var label:String = infos["label"];
			
			m_background = new FlxSprite(m_position.x, m_position.y);
			m_background.makeGraphic(m_size.x, m_size.y);
			m_label = new FlxText(m_position.x, m_position.y, m_size.x, label);
			m_label.color = FlxG.PINK;
			m_label.alignment = "center";
			
			Global.currentState.depthBuffer.addElement(m_background, DepthBuffer.s_menuGroup);
			Global.currentState.depthBuffer.addElement(m_label, DepthBuffer.s_menuGroup);
		}
		
		public function changeBackgroundColor(_color:uint) : void {
			m_background.makeGraphic(m_size.x, m_size.y, _color);
		}
		
		public function changeTextColor(_color:uint) : void {
			m_label.color = _color;
		}
		
	}

}
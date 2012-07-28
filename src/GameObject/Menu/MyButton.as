package GameObject.Menu 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MyButton extends FlxBasic
	{
		public var m_name:String;
		public var m_position:FlxPoint;
		public var m_size:FlxPoint;
		
		public var m_backgroundOnOver:uint;
		public var m_backgroundOnOut:uint;
		public var m_textOnOver:uint;
		public var m_textOnOut:uint;
		public var m_fontSize:uint;
		public var m_paddingY:int;
		public var m_text:String;
		
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
			m_fontSize = infos["fontSize"];
			m_paddingY = infos["textPaddingY"];
			
			m_text = infos["label"];
			
			m_background = new FlxSprite(m_position.x, m_position.y);
			m_background.makeGraphic(m_size.x, m_size.y);
			m_label = new FlxText(m_position.x, m_position.y + m_paddingY, m_size.x, m_text);
			m_label.color = FlxG.PINK;
			m_label.alignment = "center";
			m_label.size = m_fontSize;
			
			Global.currentState.depthBuffer.addElement(m_background, DepthBuffer.s_menuGroup);
			Global.currentState.depthBuffer.addElement(m_label, DepthBuffer.s_menuGroup);
			Global.currentState.depthBuffer.addElement(this, DepthBuffer.s_menuGroup);
		}
		
		override public function update() : void {
			m_label.text = m_text;
		}
		
		public function changeBackgroundColor(_color:uint) : void {
			m_background.makeGraphic(m_size.x, m_size.y, _color);
		}
		
		public function changeTextColor(_color:uint) : void {
			m_label.color = _color;
		}
		
		override public function destroy() : void {
			Global.currentState.depthBuffer.removeElement(m_background, DepthBuffer.s_menuGroup);
			Global.currentState.depthBuffer.removeElement(m_label, DepthBuffer.s_menuGroup);
			Global.currentState.depthBuffer.removeElement(this, DepthBuffer.s_menuGroup);
		}
	}

}
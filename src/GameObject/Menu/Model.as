package GameObject.Menu 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author ...
	 */
	public class Model extends FlxBasic
	{
		protected var m_view:View;
		
		protected var m_url:String;
		
		protected var m_loadXml:LoadXml;
		protected var m_infos:Array;
		
		protected var m_alreadySetInfos:Boolean;
		
		public function Model(_url:String) {
			this.loadUrl(_url);
		}
		
		override public function update() : void {
			if ( m_loadXml.isComplete() && m_alreadySetInfos == false ) {
				if ( m_infos.length == 0 ) {
					this.loadInfos();
					
					if ( m_view != null ) {
						m_view.setInfos(m_infos);
						m_alreadySetInfos = true;
					}
					else
						trace("too soon");
				}
			}
		}
		
		protected function loadInfos() :void {
			var data:XML = m_loadXml.m_xml;
			var items:XMLList = data.elements();
			for ( var i:int = 0; i < items.length(); i++ ) {
				var item:XML = items[i];
				var type:String = item.@type;
				var pos:FlxPoint = new FlxPoint(item.@positionx, item.@positiony);
				var size:FlxPoint = new FlxPoint(item.@sizex, item.@sizey);
				var name:String = item.@name;
				var label:String = item.@label;
				
				m_infos[i] = new Array();
				m_infos[i]["type"] = type;
				m_infos[i]["position"] = new FlxPoint(item.@positionx, item.@positiony);
				m_infos[i]["size"] = new FlxPoint(item.@sizex, item.@sizey);
				m_infos[i]["name"] = item.@name;
				m_infos[i]["label"] = item.@label;
				m_infos[i]["backgroundOnOver"] = item.@backgroundOnOver;
				m_infos[i]["backgroundOnOut"] = item.@backgroundOnOut;
				m_infos[i]["textOnOver"] = item.@textOnOver;
				m_infos[i]["textOnOut"] = item.@textOnOut;
				m_infos[i]["fontSize"] = item.@fontSize;
				m_infos[i]["textPaddingY"] = item.@textPaddingY;
			}
		}
		
		public function setView(view:View) : void {
			m_view = view;
		}
		
		public function clearInfos() : void {
			m_infos = new Array();
		}
		
		public function loadUrl(_url:String) : void {
			m_url = _url;
			
			m_loadXml = new LoadXml(m_url);
			m_infos = new Array();
			
			this.m_alreadySetInfos = false;
		}
	}

}
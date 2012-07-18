package GameObject.Menu 
{
	import GameObject.DrawableObject;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class View extends FlxBasic
	{
		protected var m_model:Model;
		protected var m_controler:Controler;
		
		protected var m_infos:Array;
		protected var m_buttons:Array;
		
		public function View() {
			m_infos = new Array();
			m_buttons = new Array();
		}
		
		override public function update() : void {
			if ( m_infos.length > 0 ) {
				if ( m_buttons.length == 0 ) {
					// creer les boutons
					for ( var i:int = 0; i < m_infos.length; i++ ) {
						var type:String = m_infos[i]["type"];
						var pos:FlxPoint = m_infos[i]["position"];
						var size:FlxPoint = m_infos[i]["size"];
						var name:String = m_infos[i]["name"];
						var label:String = m_infos[i]["label"];
						
						switch ( type ) {
							case "button":
								var mybutton = new MyButton(pos, size, name, label);
								m_buttons.push(mybutton);
								Global.currentState.depthBuffer.addElement(mybutton, DepthBuffer.s_menuGroup);
								break;
							default:
								break;
						}
					}
				}
				
				for ( var i:int = 0; i < m_buttons.length; i++ ) {
					this.checkButton(m_buttons[i]);
				}
			}
		}
		
		protected function checkButton(button:MyButton) {
			if ( isOver(button) ) {
				m_controler.onOver(button);
			}
			
			if ( isOut(button) ) {
				m_controler.onOut(button);
			}
			
			if ( isClicked(button) ) {
				m_controler.onClick(button);
			}
		}
		
		protected function isOver(button:MyButton) : Boolean {
			var isOver:Boolean = false;
			
			var pos:FlxPoint = m_model.getPosition();
			var size:FlxPoint = m_model.getSize();
			
			var mouseX:int = FlxG.mouse.screenX;
			var mouseY:int = FlxG.mouse.screenY;
			
			if ( mouseX > button.x + pos.x && mouseX < button.x + pos.x + size.x ) {
				if ( mouseY > button.y + pos.y && mouseY < button.y + pos.y + size.y ) {
					isOver = true;
				}
			}
			
			return isOver;
		}
		
		protected function isOut(button:MyButton) : Boolean {
			return !this.isOver(button);
		}
		
		protected function isClicked(button:MyButton) : Boolean {
			var isClicked:Boolean = false;
			
			if ( this.isOver(button) && FlxG.mouse.justPressed() ) {
				isClicked = true;
			}
			
			return isClicked;
		}
				
		public function print() : void {
			var pos:FlxPoint = m_model.getPosition();
			var size:FlxPoint = m_model.getSize();
			
			trace("PRINT!");
		}
		
		public function clear() : void {
		}
		
		public function changeToColorOver(button:MyButton) : void {
			button.fill(FlxG.BLACK);
		}
		
		public function changeToColorOut(button:MyButton) : void {
			button.fill(FlxG.WHITE);
		}
		
		public function setInfos(_infos:Array) : void {
			m_infos = _infos;
		}
		
		public function setModel(model:Model) : void {
			m_model = model;
		}
		
		public function setControler(controler:Controler) : void {
			m_controler = controler;
		}
	}

}
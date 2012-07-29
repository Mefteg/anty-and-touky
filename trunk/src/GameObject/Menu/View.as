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
	public class View extends FlxBasic implements ViewInterface
	{
		protected var m_model:Model;
		protected var m_controler:Controler;
		
		protected var m_infos:Array;
		protected var m_buttons:Array;
		protected var m_backgrounds:Array;
		
		public function View() {
			m_infos = new Array();
			m_buttons = new Array();
			m_backgrounds = new Array();
		}
		
		override public function update() : void {
			if ( m_infos.length > 0 ) {
				if ( m_buttons.length == 0 ) {
					// creer les boutons
					this.createButtons();
				}
				
				for ( var i:int = 0; i < m_buttons.length; i++ ) {
					this.checkButton(m_buttons[i]);
				}
			}
		}
		
		public function createButtons() : void {
			for ( var i:int = 0; i < m_infos.length; i++ ) {
				var type:String = m_infos[i]["type"];
				
				switch ( type ) {
					case "button":
						var mybutton:MyButton = new MyButton(m_infos[i]);
						m_buttons.push(mybutton);
						break;
					case "background":
						//var myBackground:MyBackground = new MyBackground(m_infos[i]);
						//myBackground.addToStage();
						//m_backgrounds.push(myBackground);
						break;
					default:
						break;
				}
			}
		}
		
		public function checkButton(button:MyButton) : void {
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
		
		public function isOver(button:MyButton) : Boolean {
			var isOver:Boolean = false;
			
			var pos:FlxPoint = button.m_position;
			var size:FlxPoint = button.m_size;
			
			var mouseX:int = FlxG.mouse.screenX;
			var mouseY:int = FlxG.mouse.screenY;
			
			if ( mouseX > pos.x && mouseX < pos.x + size.x ) {
				if ( mouseY > pos.y && mouseY < pos.y + size.y ) {
					isOver = true;
				}
			}
			
			return isOver;
		}
		
		public function isOut(button:MyButton) : Boolean {
			return !this.isOver(button);
		}
		
		public function isClicked(button:MyButton) : Boolean {
			var isClicked:Boolean = false;
			
			if ( this.isOver(button) && FlxG.mouse.justPressed() ) {
				isClicked = true;
			}
			
			return isClicked;
		}
				
		public function print() : void {			
			trace("PRINT!");
		}
		
		public function clear() : void {
			this.destroyButtons();
			m_infos = new Array();
		}
		
		protected function destroyButtons() : void {
			for ( var i:int = 0; i < m_buttons.length; i++ ) {
				var b:MyButton = m_buttons[i];
				b.destroy();
			}
			m_buttons = new Array();
		}
		
		public function changeToColorOver(button:MyButton) : void {
			button.changeBackgroundColor(button.m_backgroundOnOver);
			button.changeTextColor(button.m_textOnOver);
		}
		
		public function changeToColorOut(button:MyButton) : void {
			button.changeBackgroundColor(button.m_backgroundOnOut);
			button.changeTextColor(button.m_textOnOut);
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
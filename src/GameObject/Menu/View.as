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
		
		protected var m_loadXml:LoadXml;
		
		protected var m_buttons:Array;
		
		protected var m_start:MyButton;
		
		public function View() {
			m_buttons = new Array();
			// Récuperer le xml et créer les boutons
			m_loadXml = new LoadXml("Menu/menustate.xml");
		}
		
		override public function update() : void {
			if ( m_loadXml.isComplete() ) {
				if ( m_buttons.length == 0 ) {
					// creer les boutons
					var data:XML = m_loadXml.m_xml;
					var buttons:XMLList = data.elements();
					trace(buttons.length());
					for ( var i:int = 0; i < buttons.length(); i++ ) {
						var button:XML = buttons[i];
						var pos:FlxPoint = new FlxPoint(button.@positionx, button.@positiony);
						var size:FlxPoint = new FlxPoint(button.@sizex, button.@sizey);
						var name = button.@name;
						var label = button.@label;
						
						var mybutton = new MyButton(pos, size, name, label);
						m_buttons.push(mybutton);
						Global.currentState.depthBuffer.addElement(mybutton, DepthBuffer.s_menuGroup);
						
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
		
		public function setModel(model:Model) : void {
			m_model = model;
		}
		
		public function setControler(controler:Controler) : void {
			m_controler = controler;
		}
	}

}
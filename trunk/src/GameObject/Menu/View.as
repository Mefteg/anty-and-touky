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
		protected var m_passwords:Array;
		protected var m_tempButtons:Array;
		
		public function View() {
			m_infos = new Array();
			m_buttons = new Array();
			m_backgrounds = new Array();
			m_passwords = new Array();
			m_tempButtons = new Array();
		}
		
		override public function update() : void {
			if ( m_infos.length > 0 ) {
				if ( m_buttons.length == 0 && m_backgrounds.length == 0 ) {
					// creer les boutons
					this.createButtons();
				}
				
				for ( var i:int = 0; i < m_buttons.length; i++ ) {
					this.checkButton(m_buttons[i]);
				}
				
				for ( var k:int = 0; k < m_backgrounds.length; k++ ) {
					this.checkBackground(m_backgrounds[k]);
				}
				
				for ( var j:int = 0; j < m_tempButtons.length; j++ ) {
					this.checkTempButton(m_tempButtons[j]);
				}
			}
		}
		
		public function createButtons() : void {
			for ( var i:int = 0; i < m_infos.length; i++ )
			{
				var type:String = m_infos[i]["type"];
				
				switch ( type )
				{
					case "button":
						var mybutton:MyButton = new MyButton(m_infos[i]);
						m_buttons.push(mybutton);
						break;
					case "background":
						var myBackground:MyBackground = new MyBackground(m_infos[i]);
						myBackground.addToStage();
						Global.library.addUniqueBitmap(myBackground.m_url);
						m_backgrounds.push(myBackground);
						break;
					case "password":
						var password:PasswordManager = new PasswordManager(m_infos[i]);
						m_passwords.push(password);
						break;
					case "tempButton":
						var myTempButton:MyTempButton = new MyTempButton(m_infos[i]);
						m_tempButtons.push(myTempButton);
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
		
		public function checkBackground(_background:MyBackground) : void {
			m_controler.updateBackground(_background);
		}
		
		public function checkTempButton(_tmpButton:MyTempButton) : void {
			if ( isActive(_tmpButton) == true )
			{
				if ( isOver(_tmpButton) ) {
					m_controler.onOver(_tmpButton);
				}
				
				if ( isOut(_tmpButton) ) {
					m_controler.onOut(_tmpButton);
				}
				
				if ( isClicked(_tmpButton) ) {
					m_controler.onClick(_tmpButton);
				}
			}
			else
			{
				_tmpButton.destroy();
			}
		}
		
		public function isOver(button:MyButton) : Boolean {
			var isOver:Boolean = false;
			
			var pos:FlxPoint = button.getPosition();
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
		
		public function isActive(tmpButton:MyTempButton) : Boolean
		{
			return tmpButton.isActive();
		}
				
		public function print() : void {			
			trace("PRINT!");
		}
		
		public function clear() : void {
			this.destroyButtons();
			this.destroyBackgrounds();
			this.destroyPasswords();
			this.destroyTempButtons();
			m_infos = new Array();
		}
		
		protected function destroyBackgrounds() : void {
			for ( var i:int = 0; i < m_backgrounds.length; i++ ) {
				var b:MyBackground = m_backgrounds[i];
				b.destroy();
			}
			m_backgrounds = new Array();
		}
		
		protected function destroyButtons() : void {
			for ( var i:int = 0; i < m_buttons.length; i++ ) {
				var b:MyButton = m_buttons[i];
				b.destroy();
			}
			m_buttons = new Array();
		}
		
		protected function destroyPasswords() : void {
			for ( var i:int = 0; i < m_passwords.length; i++ ) {
				var b:PasswordManager = m_passwords[i];
				b.destroy();
			}
			m_passwords = new Array();
		}
		
		protected function destroyTempButtons() : void {
			for ( var i:int = 0; i < m_tempButtons.length; i++ ) {
				if ( m_tempButtons[i] != null )
				{
					var b:MyTempButton = m_tempButtons[i];
					b.destroy();
				}
			}
			m_tempButtons = new Array();
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
		
		public function addTempButton(_infos:Array)
		{
			var mybutton:MyTempButton = new MyTempButton(_infos);
			m_tempButtons.push(mybutton);
		}
	}

}
package GameObject.Menu 
{
	import GameObject.DrawableObject;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class View extends DrawableObject 
	{
		protected var m_model:Model;
		protected var m_controler:Controler;
		
		public function View() {
			
		}
		
		override public function update() : void {
			if ( this.mouseIsOver() ) {
				this.m_controler.mouseIsOver();
			}
		}
		
		protected function mouseIsOver() : Boolean {
			var isOver:Boolean = false;
			
			var pos:FlxPoint = m_model.getPosition();
			var size:FlxPoint = m_model.getSize();
			
			var mouseX:int = FlxG.mouse.screenX;
			var mouseY:int = FlxG.mouse.screenX;
			
			if ( mouseX > pos.x && mouseX < pos.x + size.x ) {
				if ( mouseY > pos.y && mouseY < pos.y + size.y ) {
					isOver = true;
				}
			}
			
			return isOver;
		}
				
		public function print() : void {
			var pos:FlxPoint = m_model.getPosition();
			var size:FlxPoint = m_model.getSize();
			
			this.drawLine(pos.x, pos.y, pos.x + size.x, pos.y, FlxG.BLACK);
			this.drawLine(pos.x, pos.y, pos.x + size.x, pos.y + size.y, FlxG.BLACK);
			this.drawLine(pos.x, pos.y, pos.x + size.x, pos.y + size.y, FlxG.BLACK);
			this.drawLine(pos.x, pos.y + size.y, pos.x + size.x, pos.y + size.y, FlxG.BLACK);
		}
		
		public function clear() : void {
		}
		
		public function changeBackgroundColor() : void {
			trace("CHANGE BACKGROUND COLOR");
		}
		
		public function setModel(model:Model) : void {
			m_model = model;
		}
		
		public function setControler(controler:Controler) : void {
			m_controler = controler;
		}
	}

}
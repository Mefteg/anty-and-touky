package GameObject.Menu 
{
	import GameObject.CompositeObject;
	import GameObject.DrawableObject;
	import GameObject.GameObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class ButtonMenu extends CompositeObject 
	{
		public var m_cursor:GameObject.Menu.Cursor;

		protected var m_player:GameObject.PlayableObject;
		protected var m_selectedId:int;
		
		public function ButtonMenu(player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_player = player;
			
			this.create();
		}
		
		protected function create() : void {
			var obj:Button;
			
			//creating the cursor
			m_cursor = new Cursor(m_player, this.x, this.y);
			m_cursor.m_parent = this;
			Global.library.addUniqueBitmap(m_cursor.m_url);
			// adding of the cursor
			this.add(m_cursor);
			
			if ( m_player.toString() == "Player1" ) {
				Global.cursorPlayer1 = m_cursor;
			}
			else {
				Global.cursorPlayer2 = m_cursor;
			}
			
			// adding of the attack button
			var button1:Button = new ButtonAttack(m_cursor, m_player, this.x, this.y);
			button1.m_shift = new FlxPoint(0, 0);
			button1.m_parent = this;
			Global.library.addUniqueBitmap(button1.m_url);
			this.add(button1);
			
			// adding of the magic button
			var button2:Button = new ButtonMagic(m_cursor, m_player, this.x, this.y);
			button2.m_shift = new FlxPoint(20, 0);
			button2.m_parent = this;
			Global.library.addUniqueBitmap(button2.m_url);
			this.add(button2);
			
			// adding of the item button
			var button3:Button = new ButtonItem(m_cursor, m_player, this.x, this.y);
			button3.m_shift = new FlxPoint(40, 0);
			button3.m_parent = this;
			Global.library.addUniqueBitmap(button3.m_url);
			this.add(button3);
			
			button1.m_next = button2;
			
			button2.m_next = button3;
			
			button3.m_next = button1;

			m_cursor.m_firstButton = button1;
			m_cursor.m_currentButton = button1;
		}
		
		override public function addElementToStage(element:FlxBasic):void {
			Global.currentState.depthBuffer.addMenu(element);
		}
		
		override public function update() : void {
			super.update();
			// placement
			if ( m_parent != null ) {
				this.x = m_parent.x + m_shift.x;
				this.y = m_parent.y + m_shift.y;
			}
		}
	}
}
package GameObject.Menu 
{
	import GameObject.CompositeObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class MenuBegin extends CompositeObject 
	{
		public var m_cursor:GameObject.Menu.Cursor;
		
		public function MenuBegin(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			
			this.create();
		}
		
		protected function create() : void {
			var obj:Button;
			
			//creating the cursor
			m_cursor = new CursorBegin(this.x, this.y);
			m_cursor.m_parent = this;
			Global.library.addUniqueBitmap(m_cursor.m_url);
			// adding of the cursor
			this.add(m_cursor);
			
			Global.cursorPlayer1 = m_cursor;
			Global.cursorPlayer2 = m_cursor;
			
			// adding of the background
			var background:MenuBackground = new MenuBackground(this.x, this.y);
			background.m_shift = new FlxPoint(0, 0);
			background.m_parent = this;
			Global.library.addUniqueBitmap(background.m_url);
			this.add(background);
			
			// adding of the play button
			var button1:Button = new ButtonPlay(m_cursor, null, this.x, this.y);
			button1.m_shift = new FlxPoint(220, 215);
			button1.m_parent = this;
			Global.library.addUniqueBitmap(button1.m_url);
			this.add(button1);
			
			button1.m_next = button1;

			m_cursor.m_firstButton = button1;
			m_cursor.m_currentButton = button1;
		}
		
	}

}
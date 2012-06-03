package GameObject.Menu 
{
	import GameObject.CompositeObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MenuOptions extends CompositeObject 
	{
		public var m_cursor:GameObject.Menu.Cursor;
		
		public function MenuOptions(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
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
			background.m_url = "Images/Menu/optionsstate_background.png";
			background.m_shift = new FlxPoint(0, 0);
			background.m_parent = this;
			Global.library.addUniqueBitmap(background.m_url);
			this.add(background);
			
			// adding of the incremental menu for the lifes
			var menuLifes:MenuIncremental = new MenuIncremental(m_cursor, null, this.x, this.y);
			menuLifes.m_shift = new FlxPoint(220, 215);
			menuLifes.m_parent = this;
			this.add(menuLifes);
			
			// adding of the option button
			var back:Button = new ButtonBack(m_cursor, null, this.x, this.y);
			back.m_shift = new FlxPoint(220, 315);
			back.m_parent = this;
			Global.library.addUniqueBitmap(back.m_url);
			this.add(back);

			m_cursor.m_firstButton = menuLifes.getFirst() as Button;
			m_cursor.m_currentButton = menuLifes.getFirst() as Button;
			
			(menuLifes.getLast() as Button).m_next = back;
			back.m_next = menuLifes.getFirst() as Button;
		}
	}

}
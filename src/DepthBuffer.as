package  
{
	import GameObject.Enemy.Enemy;
	import GameObject.GameObject;
	import GameObject.MovableObject;
	import GameObject.PhysicalObject;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxState;
	/**
	 * ...
	 * @author ...
	 */
	public class DepthBuffer extends FlxGroup
	{
		static public var s_backgroundGroup:int = 0;
		static public var s_menuGroup:int = 1;
		static public var s_cursorGroup:int = 2;
		
		protected var m_stage:FlxState;
		protected var m_background:FlxGroup;
		protected var m_menu:FlxGroup;
		protected var m_cursor:FlxGroup;
				
		public function DepthBuffer()
		{
			m_stage = Global.currentState;
			
			m_background = new FlxGroup();
			m_menu = new FlxGroup();
			m_cursor = new FlxGroup();
			
			add(m_background);
			add(m_menu);
			add(m_cursor);
		}
		
		/**
		 * Clear all objects except for players
		 */
		public function clearBuffers():void {
			m_background.clear();
			m_menu.clear();
			m_cursor.clear();
		}
		
		public function addElement( element:FlxBasic, group:int ) : void {
			switch ( group ) {
				case s_backgroundGroup:
					this.addBackground(element);
					break;
				case s_menuGroup:
					this.addMenu(element);
					break;
				case s_cursorGroup:
					this.addCursor(element);
					break;
				default:
					break;
			}
		}
		
		public function removeElement( element:FlxBasic, group:int ) : void {
			switch ( group ) {
				case s_backgroundGroup:
					this.removeBackground(element);
					break;
				case s_menuGroup:
					this.removeMenu(element);
					break;
				case s_cursorGroup:
					this.removeCursor(element);
					break;
				default:
					break;
			}
		}
		
		protected function addBackground(element:FlxBasic):void
		{
			m_background.add(element);
		}
		
		protected function addMenu(element:FlxBasic):void
		{
			m_menu.add(element);
		}
		
		protected function addCursor(element:FlxBasic):void
		{
			m_cursor.add(element);
		}
		
		protected function removeBackground(element:FlxBasic):void
		{
			m_background.remove(element);
		}
		
		protected function removeMenu(element:FlxBasic):void
		{
			m_menu.remove(element);
		}
		
		protected function removeCursor(element:FlxBasic):void
		{
			m_cursor.remove(element);
		}
	}

}
package  
{
	import GameObject.Enemy.Enemy;
	import GameObject.GameObject;
	import GameObject.MovableObject;
	import GameObject.PhysicalObject;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author ...
	 */
	public class DepthBuffer extends FlxGroup
	{
		private var m_stage:Playstate;
		private var m_backGround:FlxGroup;
		private var m_tiles:FlxGroup;
		private var m_objects:FlxGroup;
		private var m_players:FlxGroup;
		private var m_ennemies:FlxGroup;
		private var m_npc:FlxGroup;
		private var m_NPP:FlxGroup;
		private var m_foreGround:FlxGroup;
		private var m_menu:FlxGroup;
		private var m_cursor:FlxGroup;
				
		public function DepthBuffer()
		{
			m_stage = Global.currentState;
			m_backGround = new FlxGroup();
			m_tiles = new FlxGroup();
			m_objects = new FlxGroup();
			m_players = new FlxGroup();
			m_ennemies = new FlxGroup();
			m_npc = new FlxGroup();
			m_NPP = new FlxGroup();
			m_foreGround = new FlxGroup();
			m_menu = new FlxGroup();
			m_cursor = new FlxGroup();
			
			add(m_backGround);
			add(m_tiles);
			add(m_objects);
			add(m_ennemies);
			add(m_npc);
			add(m_players);
			add(m_NPP);
			add(m_foreGround);
			add(m_menu);
			add(m_cursor);
		}
		/**
		 * Clear all objects except for players
		 */
		public function clearBuffers():void {
			m_objects.clear();
			m_ennemies.clear();
			m_npc.clear();
			m_foreGround.clear();
			m_tiles.clear();
			m_backGround.clear();
		}
		public function addBackground(element:FlxBasic):void
		{
			m_backGround.add(element);
		}
		
		public function addObjects(element:FlxBasic):void
		{
			m_objects.add(element);
			m_stage.addPhysical(element as PhysicalObject);
		}
		
		public function addMenu(element:FlxBasic):void
		{
			m_menu.add(element);
		}
		
		public function removeMenu(element:FlxBasic):void
		{
			m_menu.remove(element);
		}
		
		public function addNPC(element:FlxBasic):void {
			m_npc.add(element);
			m_stage.addTalkers(element as MovableObject);
		}
		
		public function removeNPC(element:FlxBasic):void {
			m_npc.remove(element);
			m_stage.removeTalkers(element as MovableObject);
			m_stage.addPhysical(element as PhysicalObject);
		}
		
		public function addEnemy(element:FlxBasic):void
		{
			m_ennemies.add(element);
			m_stage.addTalkers(element as MovableObject);
			m_stage.addEnemy(element as Enemy);
			m_stage.addPhysical(element as PhysicalObject);
		}
		public function removeEnemy(element:FlxBasic):void {
			m_ennemies.remove(element);
			m_stage.removeTalkers(element as MovableObject);
			m_stage.removeEnemy(element as Enemy);
			m_stage.removePhysical(element as PhysicalObject);
		}
				
		public function addPlayer(element:FlxBasic):void
		{
			m_players.add(element);
			m_stage.addPhysical(element as GameObject.PhysicalObject);
		}
		
		public function addTile(element:FlxBasic):void
		{
			m_tiles.add(element);
		}
		
		public function addForeground(element:FlxBasic):void
		{
			m_foreGround.add(element);
		}
		
		public function addCursor(element:FlxBasic):void
		{
			m_cursor.add(element);
		}
		
		public function removeBackground(element:FlxBasic):void
		{
			m_backGround.remove(element);
		}
		
		public function removePlayer(element:FlxBasic):void
		{
			m_players.remove(element);
			m_stage.removePhysical(element as PhysicalObject);
		}
		
		public function removeObject(element:FlxBasic):void
		{
			m_objects.remove(element);
			m_stage.removePhysical(element as PhysicalObject);
		}
		
		public function removeTile(element:FlxBasic):void
		{
			m_tiles.remove(element);
		}
		
		public function removeForeground(element:FlxBasic):void
		{
			m_foreGround.remove(element);
		}
		
		public function removeCursor(element:FlxBasic):void
		{
			m_cursor.remove(element);
		}
		
		public function addNonPhysicalPlayer(element:FlxBasic):void {
			m_NPP.add(element);
		}
		
		public function removeNonPhysicalPlayer(element:FlxBasic):void {
			m_NPP.remove(element);
		}
	}

}
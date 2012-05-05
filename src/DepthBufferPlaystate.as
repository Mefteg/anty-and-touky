package  
{
	import GameObject.Enemy.Enemy;
	import GameObject.MovableObject;
	import GameObject.PhysicalObject;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author Tom
	 */
	public class DepthBufferPlaystate extends DepthBuffer 
	{
		static public var s_tileGroup:int = 10;
		static public var s_objectGroup:int = 11;
		static public var s_playerGroup:int = 12;
		static public var s_enemyGroup:int = 13;
		static public var s_npcGroup:int = 14;
		static public var s_nppGroup:int = 15;
		static public var s_foregroundGroup:int = 16;
		
		protected var m_playstate:Playstate;
		protected var m_tiles:FlxGroup;
		protected var m_objects:FlxGroup;
		protected var m_players:FlxGroup;
		protected var m_enemies:FlxGroup;
		protected var m_npc:FlxGroup;
		protected var m_NPP:FlxGroup;
		protected var m_foreGround:FlxGroup;
		
		public function DepthBufferPlaystate() 
		{
			super();
			
			m_playstate = Global.currentPlaystate;
			m_background = new FlxGroup();
			m_tiles = new FlxGroup();
			m_objects = new FlxGroup();
			m_players = new FlxGroup();
			m_enemies = new FlxGroup();
			m_npc = new FlxGroup();
			m_NPP = new FlxGroup();
			m_foreGround = new FlxGroup();
			m_menu = new FlxGroup();
			m_cursor = new FlxGroup();
			
			add(m_background);
			add(m_tiles);
			add(m_objects);
			add(m_enemies);
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
		override public function clearBuffers():void {
			m_objects.clear();
			m_enemies.clear();
			m_npc.clear();
			m_foreGround.clear();
			m_tiles.clear();
			m_background.clear();
		}
		
		override public function addElement( element:FlxBasic, group:int ) : void {
			super.addElement(element, group );
			
			switch ( group ) {
				case s_tileGroup:
					this.addTile(element);
					break;
				case s_objectGroup:
					this.addObjects(element);
					break;
				case s_playerGroup:
					this.addPlayer(element);
					break;
				case s_enemyGroup:
					this.addEnemy(element);
					break;
				case s_npcGroup:
					this.addNPC(element);
					break;
				case s_nppGroup:
					this.addNonPhysicalPlayer(element);
					break;
				case s_foregroundGroup:
					this.addForeground(element);
					break;
				default:
					break;
			}
		}
		
		override public function removeElement( element:FlxBasic, group:int ) : void {
			super.removeElement(element, group );
			
			switch ( group ) {
				case s_tileGroup:
					this.removeTile(element);
					break;
				case s_objectGroup:
					this.removeElement(element, DepthBufferPlaystate.s_objectGroup);
					break;
				case s_playerGroup:
					this.removePlayer(element);
					break;
				case s_enemyGroup:
					this.removeEnemy(element);
					break;
				case s_npcGroup:
					this.removeNPC(element);
					break;
				case s_nppGroup:
					this.removeNonPhysicalPlayer(element);
					break;
				case s_foregroundGroup:
					this.removeForeground(element);
					break;
				default:
					break;
			}
		}
		
		protected function addObjects(element:FlxBasic):void
		{
			m_objects.add(element);
			m_playstate.addPhysical(element as PhysicalObject);
		}
		
		protected function addNPC(element:FlxBasic):void {
			m_npc.add(element);
			m_playstate.addTalkers(element as MovableObject);
		}
		
		protected function removeNPC(element:FlxBasic):void {
			m_npc.remove(element);
			m_playstate.removeTalkers(element as MovableObject);
			m_playstate.addPhysical(element as PhysicalObject);
		}
		
		protected function addEnemy(element:FlxBasic):void
		{
			m_enemies.add(element);
			m_playstate.addTalkers(element as MovableObject);
			m_playstate.addEnemy(element as Enemy);
			//m_stage.addPhysical(element as PhysicalObject);
		}
		protected function removeEnemy(element:FlxBasic):void {
			m_enemies.remove(element);
			m_playstate.removeTalkers(element as MovableObject);
			m_playstate.removeEnemy(element as Enemy);
			//m_stage.removePhysical(element as PhysicalObject);
		}
				
		protected function addPlayer(element:FlxBasic):void
		{
			m_players.add(element);
			m_playstate.addPhysical(element as GameObject.PhysicalObject);
		}
		
		protected function addTile(element:FlxBasic):void
		{
			m_tiles.add(element);
		}
		
		protected function addForeground(element:FlxBasic):void
		{
			m_foreGround.add(element);
		}
		
		protected function removePlayer(element:FlxBasic):void
		{
			m_players.remove(element);
			m_playstate.removePhysical(element as PhysicalObject);
		}
		
		protected function removeObject(element:FlxBasic):void
		{
			m_objects.remove(element);
			m_playstate.removePhysical(element as PhysicalObject);
		}
		
		protected function removeTile(element:FlxBasic):void
		{
			m_tiles.remove(element);
		}
		
		protected function removeForeground(element:FlxBasic):void
		{
			m_foreGround.remove(element);
		}
		
		protected function addNonPhysicalPlayer(element:FlxBasic):void {
			m_NPP.add(element);
		}
		
		protected function removeNonPhysicalPlayer(element:FlxBasic):void {
			m_NPP.remove(element);
		}
		
	}

}
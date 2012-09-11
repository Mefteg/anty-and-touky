package GameObject.Menu 
{
	import GameObject.Armor.Armor;
	import GameObject.CompositeObject;
	import GameObject.DrawableObject;
	import GameObject.GameObject;
	import GameObject.Menu.MenuHeart;
	import GameObject.PlayableObject;
	import org.flixel.FlxBasic;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Menu extends CompositeObject 
	{
		protected var m_player:PlayableObject;
		
		private var m_menuHeart:GameObject.Menu.MenuHeart;
		private var m_menuShield:GameObject.Menu.MenuShield;
		
		private var m_lastHeart:int;
		
		public function Menu(player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			
			m_player = player;
			m_width = 120;
			m_height = 45;
			
			this.create();
		}
		
		protected function create() : void {
			var obj:GameObject;
			// adding of the frame
			obj = new FrameMenu();
			obj.m_parent = this;
			if (m_player.m_name == "Player1")
				obj.m_url = "Images/Menu/menu_frame_anty.png";
			else	
				obj.m_url = "Images/Menu/menu_frame_touky.png";
			Global.library.addUniqueBitmap(obj.m_url);
			this.add(obj);
			
			// adding of the heart menu
			m_menuHeart = new GameObject.Menu.MenuHeart(m_player, this.x, this.y);
			m_menuHeart.m_parent = this;
			m_menuHeart.m_shift = new FlxPoint(10, 8);
			m_menuHeart.addIcons(m_player.m_initHealth);
			m_lastHeart = m_player.m_initHealth -1;
			this.add(m_menuHeart);
			
			// adding of the shield menu
			m_menuShield = new GameObject.Menu.MenuShield(m_player, this.x, this.y);
			m_menuShield.m_parent = this;
			m_menuShield.m_shift = new FlxPoint(10, 8);
		}
		
		override public function addElementToStage(element:FlxBasic):void {
			Global.currentState.depthBuffer.addElement(element, DepthBuffer.s_menuGroup);
		}
		
		override public function update() : void {
			super.update();
			var pos_cam:FlxPoint = Global.currentState.m_camera.getCornerPosition();
			this.x = pos_cam.x + m_shift.x;
			this.y = pos_cam.y + m_shift.y;
			
			var shiftX:int = m_menuHeart.m_shift.x + (m_menuHeart.m_objects.length) * 9;
			var shiftY:int = m_menuHeart.m_shift.y;
			m_menuShield.m_shift = new FlxPoint(shiftX, shiftY);
		}
		
		public function takeDamage() : void {
			/*if ( m_menuHeart.m_objects.length > 0 ) {
				m_menuHeart.remove(m_menuHeart.getLast());
			}*/
			m_menuHeart.m_objects[m_lastHeart].visible = false;
			m_lastHeart --;
		}
		
		public function addHeart() : void {
			if (m_lastHeart < m_player.m_initHealth - 1) {
				m_lastHeart++;
				m_menuHeart.m_objects[m_lastHeart].visible = true;
			}
		}
		
		public function addHearts(count:int) : void {
			for (var i:int = 0; i < count; i++)
				addHeart();
		}
		
		public function reInitHearts():void {
			m_lastHeart = m_player.m_initHealth -1;
			for (var i:int = 0; i < m_lastHeart + 1; i++)
				m_menuHeart.m_objects[i].visible = true;
		}
		
		public function addShield() : void {
			m_menuShield.addIcon();
		}
		
	}

}
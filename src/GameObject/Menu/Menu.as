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
			Global.library.addUniqueBitmap(obj.m_url);
			this.add(obj);
			
			// adding of the heart menu
			m_menuHeart = new GameObject.Menu.MenuHeart(m_player, this.x, this.y);
			m_menuHeart.m_parent = this;
			m_menuHeart.m_shift = new FlxPoint(10, 8);
			this.add(m_menuHeart);
			
			// adding of the shield menu
			m_menuShield = new GameObject.Menu.MenuShield(m_player, this.x, this.y);
			m_menuShield.m_parent = this;
			m_menuShield.m_shift = new FlxPoint(10, 8);
			this.add(m_menuShield);
		}
		
		override public function addElementToStage(element:FlxBasic):void {
			Global.currentState.depthBuffer.addMenu(element);
		}
		
		override public function update() : void {
			super.update();
			var pos_cam:FlxPoint = Global.currentState.m_camera.getCornerPosition();
			this.x = pos_cam.x + m_shift.x;
			this.y = pos_cam.y + m_shift.y;
			
			var shiftX:int = m_menuHeart.m_shift.x + (m_menuHeart.m_objects.length + 1) * 9;
			var shiftY:int = m_menuHeart.m_shift.y;
			m_menuShield.m_shift = new FlxPoint(shiftX, shiftY);
			
			if ( FlxG.keys.justPressed("N") ) {
				this.takeDamage();
			}
		}
		
		public function takeDamage() {
			if ( m_menuShield.m_objects.length > 0 ) {
				m_menuShield.remove(m_menuShield.getLast());
			}
			else {
				if ( m_menuHeart.m_objects.length > 0 ) {
					m_menuHeart.remove(m_menuHeart.getLast());
				}
			}
		}
	}

}
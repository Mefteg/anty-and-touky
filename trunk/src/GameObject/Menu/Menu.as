package GameObject.Menu 
{
	import GameObject.Armor.Armor;
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
	public class Menu extends CompositeObject 
	{
		protected var m_player:PlayableObject;
		public function Menu(player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			
			m_player = player;
			m_width = 120;
			m_height = 45;
			
			var obj:GameObject;
			// adding of the frame
			obj = new FrameMenu();
			obj.m_parent = this;
			Global.library.addUniqueBitmap(obj.m_url);
			this.add(obj);
			
			// adding of the HP bar
			obj = new HPBar(m_player, this.x, this.y);
			obj.m_parent = this;
			obj.m_shift = new FlxPoint(10, 8);
			Global.library.addUniqueBitmap(obj.m_url);
			this.add(obj);
			
			// adding of the MP bar
			obj = new MPBar(m_player, this.x, this.y);
			obj.m_shift = new FlxPoint(10, 22);
			obj.m_parent = this;
			Global.library.addUniqueBitmap(obj.m_url);
			this.add(obj);

			// adding of the button menu
			obj = new ButtonMenu(m_player, this.x, this.y);
			obj.m_shift = new FlxPoint(10, 36);
			obj.m_parent = this;
			this.add(obj);
		}
		
		override public function addElementToStage(element:FlxBasic):void {
			Global.currentState.depthBuffer.addMenu(element);
		}
		
		override public function update() : void {
			super.update();
			var pos_cam:FlxPoint = Global.currentState.m_camera.getCornerPosition();
			this.x = pos_cam.x + m_shift.x;
			this.y = pos_cam.y + m_shift.y;
		}
	}

}
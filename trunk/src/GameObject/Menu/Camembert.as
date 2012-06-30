package GameObject.Menu 
{
	import GameObject.DrawableObject;
	import GameObject.GameObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Camembert extends DrawableObject 
	{
		private var m_target:GameObject;
		private var m_timer:FlxTimer;
		
		private var m_reverse:Boolean = false;
		
		public function Camembert(target:GameObject) 
		{
			super(0, 0);
			m_target = target;
			m_state = "idle";
			m_timer = new FlxTimer();
			m_url = "Images/Menu/camenbert.png";
			m_width = 16; m_height = 16;
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.addElement(this, DepthBuffer.s_menuGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentState.depthBuffer.removeElement(this, DepthBuffer.s_menuGroup);
		}
		
		override public function load():void {
			super.load();
			addAnimation("display", [0, 1, 2, 3, 4, 5, 6, 7], 12, false);
		}
		
		public function trigger(time:Number , reverse = false):void {
			m_state = "display";
			m_timer.start(time);
			m_reverse = reverse;
			addToStage();
		}
		override public function update():void {
			if (m_state == "display") {
				x = m_target.x; y = m_target.y - 16;
				manageGraphic();				
				if (m_timer.finished) {
					m_state = "idle";
					removeFromStage();
				}
			}
		}
		
		public function manageGraphic():void {
			if(!m_reverse)
				frame = m_timer.progress * 7;
			else
				frame = (1 - m_timer.progress) * 7;
		}
		
	}

}
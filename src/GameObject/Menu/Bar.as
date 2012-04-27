package GameObject.Menu 
{
	import GameObject.DrawableObject;
	import GameObject.GameObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Bar extends DrawableObject 
	{
		protected var m_player:PlayableObject;
		protected var m_original_x:Number;
		
		public function Bar(player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_player = player;
			m_url = "Images/Menu/hpbar.png";
			m_width = 100;
			m_height = 8;
			m_original_x = this.x;
			m_shift = new FlxPoint(0,0);
		}
		
		override public function update() : void {
			super.update();
			// placement
			if ( m_parent != null ) {
				this.x = m_parent.x + m_shift.x;
				this.y = m_parent.y + m_shift.y;
			}
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.addMenu(this);
		}
	}

}
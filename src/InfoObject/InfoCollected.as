package InfoObject 
{
	import GameObject.DrawableObject;
	import GameObject.MovableObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	/**
	 * ...
	 * @author ...
	 */
	public class InfoCollected extends MovableObject
	{
		private var m_timer:FlxTimer;
		private var m_up:Number;
		
		public function InfoCollected(X:Number,Y:Number,url:String) 
		{
			super(X, Y);
			m_timer = new FlxTimer();
			m_timer.start(2);
			m_url = url;
			m_width = 16;
			m_height = 16;
			m_up = 3;
			loadGraphic2(Global.library.getBitmap(m_url), false, false, m_width, m_height);
			addToStage();
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.removeElement(this, DepthBuffer.s_menuGroup);
		}
				
		override public function removeFromStage():void {
			Global.currentState.depthBuffer.removeElement(this, DepthBuffer.s_menuGroup);
		}
		
		override public function update():void {
			if (m_timer.finished)
				removeFromStage();
				
			this.y -= m_up;
			
			m_up -= 0.2;
			if (m_up < 0)
				m_up = 0;
		}
		
	}

}
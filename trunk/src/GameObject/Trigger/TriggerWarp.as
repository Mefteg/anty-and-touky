package GameObject.Trigger 
{
	import GameObject.TriggerObject;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author ...
	 */
	public class TriggerWarp extends TriggerObject
	{
		protected var m_sceneName:String;
		protected var m_respawnPoint:String;
		
		public function TriggerWarp(X:Number=0, Y:Number=0,SimpleGraphic:Class=null,sceneName:String=null,respawn:String=null,width:int=0,height:int=0) 
		{
			super(X, Y, SimpleGraphic, width, height);
			m_sceneName = sceneName;
			m_respawnPoint = respawn;
			this.visible = false;
		}
		
		override public function update() : void {
			/*if (!m_active && ( collide(Global.player1) || collide(Global.player2))) {
				m_active = true;
				Global.currentPlaystate.changeScene(m_sceneName, m_respawnPoint);
				Global.player1.block();
				Global.player2.block();
			}*/
		}
		
	}

}
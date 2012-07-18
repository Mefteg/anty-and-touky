package GameObject.Other 
{
	import GameObject.PhysicalObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Door extends PhysicalObject 
	{
		protected var m_respawnOffset:FlxPoint;
		
		public function Door(X:Number, Y:Number, name:String, respawn:String ) 
		{
			super(X, Y);
			m_url = "Images/Others/spikes.png";
			m_name = name;
			m_width = 48; m_height = 48;
			computeRespawnPoint(respawn);			
		}
		override public function addToStage():void {
			Global.currentPlaystate.addPhysical(this as PhysicalObject);
			Global.currentPlaystate.addDoor(this);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.removeDoor(this);
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function act():void {
			m_collideWithObjects = false;
			frame = 1;
		}
		
		public function close():void {
			m_collideWithObjects = true;
			frame = 0;
			if (collide(Global.player1)) {
				replace(Global.player1);
			}
			if (collide(Global.player2)) {
				replace(Global.player2);
			}
		}
		
		private function replace(player:PlayableObject):void {
			player.takeDamage();
			player.place(m_respawnOffset.x,m_respawnOffset.y);
		}
		
		private function computeRespawnPoint(respawn:String):void {
			switch(respawn) {
				case "right": m_respawnOffset = new FlxPoint(x + m_width + 1, y);
					break;
				case "left": m_respawnOffset = new FlxPoint( x - 50, y);
					break;
				case "down": m_respawnOffset = new FlxPoint(x, y+m_height+1);
					break;
				case "up": m_respawnOffset = new FlxPoint(x, y-50);
					break;
				default :  m_respawnOffset = new FlxPoint(x + m_width + 1, y);
			}
		}
	}

}
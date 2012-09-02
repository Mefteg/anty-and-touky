package GameObject.Other 
{
	import GameObject.InteractiveObject;
	import GameObject.PhysicalObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Door extends InteractiveObject 
	{
		protected var m_respawnOffset:FlxPoint;
		public var m_hazardous:Boolean = false;
		
		public var m_animationSpeed:int = 0;
		public var m_frameOpen:int = 1;
				
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
			if (m_hazardous)
				play("idle");
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.removeDoor(this);
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function act():void {
			m_collideWithObjects = false;
			m_hazardous = false;
			frame = m_frameOpen;
		}
		
		public function setAnimation(...rest):void {
			addAnimation("idle", rest, m_animationSpeed, true);
		}
		
		override public function update():void {
			if (m_hazardous) {
				if (Global.soloPlayer) {
					if (canInteract(Global.soloPlayer))
						Global.soloPlayer.takeDamage();
					return;
				}
				if (canInteract(Global.player1)){
					Global.player1.resetTwinkle();
					Global.player1.takeDamage();
				}
				if (canInteract(Global.player2)){
					Global.player2.resetTwinkle();
					Global.player2.takeDamage();
				}
			}
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
		
		public static function Cylinders(X:Number, Y:Number, name:String, respawn:String ):Door {
			var cyl:Door = new Door(X, Y, name, respawn);
			cyl.m_url = "Images/Others/cylinders.png";
			return cyl;
		}
		
		public static function ElectricDoor(X:Number, Y:Number, name:String, respawn:String ):Door {
			var ed:Door = new Door(X, Y, name, respawn);
			ed.m_url = "Images/Others/electric_door.png";
			ed.m_animationSpeed = 13;
			ed.setAnimation(0, 1);
			ed.m_frameOpen = 2;
			ed.m_hazardous = true;
			return ed;
		}
	}

}
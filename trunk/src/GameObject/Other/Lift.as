package GameObject.Other 
{
	import flash.geom.Rectangle;
	import GameObject.MovableObject;
	import GameObject.PlayableObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Lift extends MovableObject 
	{
		private var m_initY:Number;
		private var range:int = 96;
		
		private var m_player1Off:Boolean = false;
		private var m_player2Off:Boolean = false;
		
		public function Lift(X:Number,Y:Number, newRange:int) 
		{
			super(X, Y);
			m_initY = Y;
			if (newRange != 0)
				range = newRange * 32;
			m_url = "Images/Others/metal_lift.png";
			m_width = 96; m_height = 96;
			m_bufferGroup = DepthBufferPlaystate.s_objectGroup;
			m_direction = new FlxPoint(0, -1);
			m_typeName = "Lift";
			m_state = "idle";
		}
		
		override public function update():void {
			if (Global.frozen)
				return;
			switch(m_state) {
				case "idle" : waitForPlayers(); break;
				case "movingUp": moveUp(); break;
				case "stopped" : stay(); break;
				case "done" : done(); break;
				default : break;					
			}
		}
		
		public function waitForPlayers():void {
			/*if (Global.soloPlayer && waitFor(Global.soloPlayer)) {
				Global.soloPlayer.m_collideEvtFree = true;
				m_state = "movingUp";
				return;
			}*/
			if (waitFor(Global.player1) && waitFor(Global.player2)) {
				Global.player1.m_collideEvtFree = true;
				Global.player2.m_collideEvtFree = true;
				Global.player1.setThrowablesPierce(true);
				Global.player2.setThrowablesPierce(true);
				m_state = "movingUp";
			}
		}
		
		private function waitFor(player:PlayableObject):Boolean {
			if (isPlayerOn(player))
				return true;
			return false;
		}
		
		public function moveUp():void {
			preventFalling();
			
			Global.player1.y += y - m_oldPos.y;
			Global.player2.y += y - m_oldPos.y;
			move();
			
			if (y < m_initY - range ){
				m_state = "stopped";
				Global.player1.setThrowablesPierce(false);
				Global.player2.setThrowablesPierce(false);
			}
		}
		
		function stay():void {			
			if (!m_player1Off) {
				//prevent players from going down
				if (Global.player1.y + 48 > y +m_height) {
					Global.player1.y = y+m_height-48;
				}else if(!collide( Global.player1 ) ) {
					m_player1Off = true;
					Global.player1.m_collideEvtFree = false;
				}
			}
			
			if (!m_player2Off) {
				//prevent players from going down
				if (Global.player2.y + 48 > y +m_height) {
					Global.player2.y = y+m_height-48;
				}else if(!collide( Global.player2 ) ) {
					m_player2Off = true;
					Global.player2.m_collideEvtFree = false;
				}
			}
			if (m_player1Off && m_player2Off)
				m_state = "done";
		}
		
		private function done():void {
			if (collide(Global.player1)) {
				//prevent players from going down
				if (Global.player1.y + 48 > y +m_height) {
					Global.player1.y = y+m_height-48;
				}
			}
			
			if (collide(Global.player2)) {
				//prevent players from going down
				if (Global.player2.y + 48 > y +m_height) {
					Global.player2.y = y+m_height-48;
				}
			}
		}
		
		function preventFalling():void {
			if ( !isPlayerOn(Global.player1))
				Global.player1.replaceToOld();
			if ( !isPlayerOn(Global.player2))
				Global.player2.replaceToOld();
		}
		
		function isPlayerOn(player:PlayableObject):Boolean {
			return getHitboxRect().containsRect(player.getHitboxRect());
		}
	}

}
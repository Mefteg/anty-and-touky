package GameObject 
{
	import flash.geom.Rectangle;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class InteractiveObject extends PhysicalObject 
	{
		public var m_hitboxInteraction:Hitbox;
		protected var m_player1In:Boolean = false;
		protected var m_player2In:Boolean = false;
		protected var m_hasToFreePlayers:Boolean = false;
		
		public function InteractiveObject(X:Number, Y:Number ) 
		{
			super(X, Y);
		}
		
		public function setHitboxInteract(X:int, Y:int, W:int, H:int) : void {
			m_hitboxInteraction = new Hitbox(X, Y, W, H);
		}
		
		public function canInteract(player:PlayableObject):Boolean {
			var myRect:Rectangle = new Rectangle(x + m_hitboxInteraction.x, y + m_hitboxInteraction.y, m_hitboxInteraction.width, m_hitboxInteraction.height);
			var otherRect:Rectangle = new Rectangle(player.x + player.m_hitbox.x, player.y + player.m_hitbox.y, player.m_hitbox.width, player.m_hitbox.height);
			if (myRect.intersects(otherRect)) {
				if (player.toString() == "Player1")
					m_player1In = true;
				else 
					m_player2In = true;
				return true;
			}
			if (player.toString() == "Player1")
					m_player1In = false;
				else 
					m_player2In = false;
			return false;
		}
		
		protected function freePlayers():void {
			if(m_player1In)
				Global.cursorPlayer1.m_enabled = true;
			if(m_player2In)
				Global.cursorPlayer2.m_enabled = true;
			m_hasToFreePlayers = false;
		}
		
		public function drawHitboxInter():void {
			var spr:FlxSprite = new FlxSprite(x+m_hitboxInteraction.x, y+m_hitboxInteraction.y);
			spr.makeGraphic(m_hitboxInteraction.width, m_hitboxInteraction.height);
			Global.currentPlaystate.depthBuffer.addElement(spr, DepthBufferPlaystate.s_objectGroup);
		}
		
	}

}
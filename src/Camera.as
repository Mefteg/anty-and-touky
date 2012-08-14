package  
{
	import GameObject.PlayableObject;
	import org.flixel.FlxCamera;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class Camera extends FlxCamera 
	{
		protected var m_aabb:FlxPoint;
		protected var m_target:FlxPoint;
		protected var m_nbTilesOffset:int = 3;

		public function Camera(X:int, Y:int, Width:int, Height:int, Zoom:Number=0) 
		{
			super(X, Y, Width, Height, Zoom);
			//m_aabb = new FlxPoint(Width * 0.775, Height * 0.775);
			m_aabb = new FlxPoint(Width - m_nbTilesOffset * Global.tile_width, Height - m_nbTilesOffset * Global.tile_height);
			m_target = new FlxPoint(Width * 0.5, Height * 0.5);
			this.focusOn(m_target);
		}
		
		override public function update() : void {
			var oldScroll:FlxPoint = this.scroll;
			if ( Global.player1 && Global.player2 ) {
				var pos_p1:FlxPoint = new FlxPoint(Global.player1.x, Global.player1.y);
				var size_p1:FlxPoint = new FlxPoint(Global.player1.m_width, Global.player1.m_height);
				var center_p1:FlxPoint = Utils.add2v(pos_p1, Utils.mult1v(size_p1, 0.5));
				
				var pos_p2:FlxPoint = new FlxPoint(Global.player2.x, Global.player2.y);
				var size_p2:FlxPoint = new FlxPoint(Global.player2.m_width, Global.player2.m_height);
				var center_p2:FlxPoint = Utils.add2v(pos_p2, Utils.mult1v(size_p2, 0.5));
				
				m_target = Utils.mult1v(Utils.add2v(pos_p1, pos_p2), 0.5);
				
				if ( !this.isIn(pos_p1, size_p1) ) {
					stopPlayer(Global.player1);
				}
				if ( !this.isIn(pos_p2, size_p2) ) {
					stopPlayer(Global.player2);
				}
				
				if ( m_target.x - 320 < 0 ) {
					m_target.x = 320;
				}
				
				if ( m_target.y - 240 < 0 ) {
					m_target.y = 240;
				}
				
				if ( m_target.x + 320 > Global.nb_tiles_width * 32 ) {
					m_target.x = Global.nb_tiles_width * 32 - 320;
				}
				
				if ( m_target.y + 240 > Global.nb_tiles_height * 32 ) {
					m_target.y = Global.nb_tiles_height * 32 - 240;
				}
				
				this.focusOn(m_target);
			}
		}
		
		public function getCornerPosition() : FlxPoint {
			return new FlxPoint(m_target.x - this.width * 0.5, m_target.y - this.height * 0.5);
		}
		
		protected function followPlayer(player:PlayableObject) : void {			
			m_target = Utils.add2v(m_target, Utils.mult1v(player.m_direction, player.m_speed));
		}
		
		protected function isIn(pos:FlxPoint, size:FlxPoint) : Boolean {
			var left:Number = pos.x;
			var right:Number = left + size.x;
			var top:Number = pos.y;
			var bottom:Number = top + size.y;
			
			if ( left < m_target.x - m_aabb.x * 0.5 ) {
				return false;
			}
			
			if ( right > m_target.x + m_aabb.x * 0.5 ) {
				return false;
			}
			
			if ( top < m_target.y - m_aabb.y * 0.5 ) {
				return false;
			}
			
			if ( bottom > m_target.y + m_aabb.y * 0.5 ) {
				return false;
			}
			
			return true;
		}
		
		protected function stopPlayer(player:PlayableObject) : void {
			var pos:FlxPoint = new FlxPoint(player.x, player.y);
			var size:FlxPoint = new FlxPoint(player.m_width, player.m_height);
			
			var left:Number = pos.x;
			var right:Number = left + size.x;
			var top:Number = pos.y;
			var bottom:Number = top + size.y;
			
			if ( left < m_target.x - m_aabb.x * 0.5 ) {
				player.m_scrollBlockLeft = true;
			}
			
			if ( right > m_target.x + m_aabb.x * 0.5 ) {
				player.m_scrollBlockRight = true;
			}
			
			if ( top < m_target.y - m_aabb.y * 0.5 ) {
				player.m_scrollBlockUp = true;
			}
			
			if ( bottom > m_target.y + m_aabb.y * 0.5 ) {
				player.m_scrollBlockDown = true;
			}
		}
	}

}
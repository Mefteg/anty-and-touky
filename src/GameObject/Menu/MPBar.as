package GameObject.Menu 
{
	import GameObject.PlayableObject;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Tom
	 */
	public class MPBar extends Bar 
	{
		public function MPBar(player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(player, X, Y, SimpleGraphic);
			m_url = "Images/Menu/mpbar.png";
		}
		
		override public function update() : void {
			super.update();
			
			if ( m_player ) {
				var ratio_mp:Number = m_player.m_stats.m_mp_current / m_player.m_stats.m_mp_max;
				this.scale = new FlxPoint(ratio_mp, 1);
				this.x = this.x - (1 - ratio_mp) * m_width * 0.5;
			}
		}
	}

}
package GameObject.Menu 
{
	import GameObject.PlayableObject;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Tom
	 */
	public class HPBar extends Bar 
	{
		public function HPBar(player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(player, X, Y, SimpleGraphic);
			m_url = "Images/Menu/hpbar.png";
		}
		
		override public function update() : void {
			super.update();
			if ( m_player ) {
				var ratio_hp:Number = m_player.m_stats.m_hp_current / m_player.m_stats.m_hp_max;
				this.scale = new FlxPoint(ratio_hp, 1);
				this.x = this.x - (1 - ratio_hp) * m_width * 0.5;
			}
		}
	}

}
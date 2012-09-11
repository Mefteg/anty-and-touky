package GameObject.Item 
{
	import com.adobe.utils.NumberFormatter;
	import flash.display.ColorCorrectionSupport;
	import GameObject.PlayableObject;
	/**
	 * ...
	 * @author ...
	 */
	public class SpecialFiller extends Collectable 
	{
		public var m_player:PlayableObject;
		
		public function SpecialFiller(X:Number, Y:Number) 
		{
			super(X, Y);
		}
		
		override public function load():void {
			super.load();
			addAnimation("idle", [0, 1, 2, 3], 4, true);
			play("idle");
		}
		
		override public function act():void {
			m_player.addSpecial(m_power);
			m_sound.play();
			removeFromStage();
		}
		
		override public function update():void {
			//si on joue tout seul
			if (Global.soloPlayer) {
				//si c'est le bon player qui est courant
				if (Global.soloPlayer.m_name == m_player.m_name) 
					//et enfin si il collide bien
					if(collide(m_player))
						act();
			//sinon
			}else {
				if(collide(m_player))
						act();
			}
		}
		
		public static function GoldFeather(X:Number, Y:Number) : SpecialFiller {
			var gf:SpecialFiller = new SpecialFiller(X, Y);
			gf.m_url = "Images/Items/gold_feather.png";
			gf.m_width = 32; gf.m_height = 32;
			gf.m_player = Global.player2;
			gf.m_power = 10;
			return gf;
		}
		
		public static function GoldAnt(X:Number, Y:Number) : SpecialFiller {
			var gf:SpecialFiller = new SpecialFiller(X, Y);
			gf.m_url = "Images/Items/gold_ant.png";
			gf.m_width = 32; gf.m_height = 32;
			gf.m_player = Global.player1;
			gf.m_power = 6;
			return gf;
		}
		
	}

}
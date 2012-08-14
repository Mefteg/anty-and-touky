package GameObject.Item 
{
	/**
	 * ...
	 * @author ...
	 */
	public class SuperShotFiller extends SpecialFiller 
	{
		
		public function SuperShotFiller(X:Number, Y:Number) 
		{
			super(X, Y);			
		}
		
		override public function act():void {
			m_player.addSuperShots();
			removeFromStage();
		}
		
		override public function load():void {
			super.load();
			addAnimation("glow", [0, 1, 2, 3], 5, true);
			play("glow");
		}
		
		public static function BigEgg(X:Number, Y:Number) : SuperShotFiller {
			var gf:SuperShotFiller = new SuperShotFiller(X, Y);
			gf.m_url = "Images/Items/big_egg.png";
			gf.m_width = 32; gf.m_height = 32;
			gf.m_player = Global.player2;
			return gf;
		}
		
		public static function BigAnt(X:Number, Y:Number) : SuperShotFiller {
			var gf:SuperShotFiller = new SuperShotFiller(X, Y);
			gf.m_url = "Images/Items/big_ant.png";
			gf.m_width = 32; gf.m_height = 32;
			gf.m_player = Global.player1;
			return gf;
		}
	}

}
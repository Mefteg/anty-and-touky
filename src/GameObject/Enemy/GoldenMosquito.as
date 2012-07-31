package GameObject.Enemy 
{
	import GameObject.Item.Collectable;
	import GameObject.Item.SpecialFiller;
	/**
	 * ...
	 * @author ...
	 */
	public class GoldenMosquito extends Mosquito
	{
		
		public function GoldenMosquito(X:Number,Y:Number) 
		{
			super(X, Y);
			m_url = "Images/Enemies/mosquito_shiny.png";
		}
		
		override public function addBitmap():void {
			super.addBitmap();
			Global.library.addBitmap("Images/Items/gold_feather.png");
		}
		
		override protected function dropItem():void {
			var item:SpecialFiller = SpecialFiller.GoldFeather(x, y);
			item.addToStage();
		}
	}

}
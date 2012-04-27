package GameObject.Enemy 
{
	import GameObject.IAObject;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class BlackSquare extends Enemy 
	{
		
		public function BlackSquare(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_url = "Images/Enemies/BlackSquare.png";
		}
		
		override public function update() : void {
		}
		
	}

}
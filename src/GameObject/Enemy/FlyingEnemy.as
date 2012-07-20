package GameObject.Enemy 
{
	/**
	 * ...
	 * @author Tom
	 */
	public class FlyingEnemy extends Enemy 
	{
		static public var s_type:String = "FlyingEnemy";
		
		public function FlyingEnemy(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_typeName = s_type;
		}
		
	}

}
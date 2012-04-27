package GameObject 
{
	/**
	 * ...
	 * @author Tom
	 */
	public class TriggerObject extends GameObject 
	{
		
		protected var m_active:Boolean;
		
		public function TriggerObject(X:Number=0, Y:Number=0,SimpleGraphic:Class=null, width:int=0,height:int=0) 
		{
			super(X, Y, SimpleGraphic);
			m_height = height;
			m_width = width;
			m_hitbox = new Hitbox(0, 0, width, height);
			m_active = false;
		}
		
	}

}
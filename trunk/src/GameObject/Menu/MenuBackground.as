package GameObject.Menu 
{
	import GameObject.DrawableObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MenuBackground extends DrawableObject 
	{
		public function MenuBackground(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_url = "Images/Menu/menustate_background.png";
			m_width = 640;
			m_height = 480;
		}
		
	}

}
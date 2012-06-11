package GameObject.Menu 
{
	import GameObject.PlayableObject;
	
	/**
	 * ...
	 * @author Tom
	 */
	public class SubMenu extends Menu 
	{
		
		public function SubMenu(player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(player, X, Y, SimpleGraphic);
			
		}
		
		override public function update() : void {
			// placement
			if ( m_parent != null ) {
				this.x = m_parent.x + m_shift.x;
				this.y = m_parent.y + m_shift.y;
			}
		}
		
		public function addIcon() : void {
			
		}
		
		public function addIcons(count:int ):void {
			for (var i:int = 0; i < count; i++)
				this.addIcon();
		}
	}

}
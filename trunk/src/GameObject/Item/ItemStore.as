package GameObject.Item 
{
	import GameObject.PlayableObject;
	/**
	 * ...
	 * @author ...
	 */
	public class ItemStore 
	{
		public var m_item:Item;
		public var m_quantity:int;
		public var m_player:PlayableObject;
		
		public function ItemStore(item:Item, qty:int,player:PlayableObject) {
			m_item = item;
			m_item.m_caster = player;
			m_quantity = qty;
			m_player = player;
		}
		
		public function useIt():void {
			m_player.useItem();
			m_item.useIt();
			m_quantity--;
			if(m_quantity == 0){
				m_player.m_itemManager.removeUsableItem(m_item.m_name);
				m_player.m_itemManager.removeItem(m_item.m_name);
			}
		}
		
		public function getName():String {
			return m_item.m_name;
		}
		
		public function getIconURL():String {
			return m_item.m_iconImage;
		}
		
	}

}
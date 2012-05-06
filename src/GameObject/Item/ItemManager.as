package GameObject.Item 
{
	import GameObject.Converter;
	import GameObject.PlayableObject;
	/**
	 * ...
	 * @author ...
	 */
	
	public class ItemManager 
	{
		public var m_items:Object;
		public var m_usableItem:Vector.<ItemStore>;
		public var m_nbUsable:int = 4;
		public var m_player:PlayableObject;
		
		public function ItemManager(player:PlayableObject) 
		{
			m_items = new Object();
			m_player = player;
			m_usableItem = new Vector.<ItemStore>();
		}
		
		public function addToLibrary():void {
			for(var name:String in m_items)
				m_items[name].m_item.addBitmap();
		}
		
		public function load():void {
			for(var name:String in m_items)
				m_items[name].m_item.load();
		}
		
		public function addItem(name:String,qty:int):void {
			//if the object exists in the manager
			if (!m_items[name]){
				var item:Item = Converter.instantiateItem(name);
				m_items[name] = new ItemStore(item, qty, m_player);
				item.load();
				if (m_usableItem.length < m_nbUsable)
					addUsableItem(name);
				return;
			}
			m_items[name].m_quantity += qty;
		}
		
		public function addUsableItem(name:String) : Boolean {
			if (m_usableItem.length == m_nbUsable || m_items[name]==null)
				return false;
				
			m_usableItem.push(m_items[name]);
			
			return true;
		}
		
		public function removeUsableItem(name:String) : Boolean {
			m_usableItem.splice(m_usableItem.indexOf(m_items[name]), 1);
			return true;
		}
		
		public function removeItem(name:String):void {
			m_items[name] = null;
			delete m_items[name];
		}
		
		public function getUsableItems():Vector.<ItemStore> {
			return m_usableItem;
		}
		
		public function useItem(name:String):void {
			if(m_items[name])
				m_items[name].useIt();
		}		
	}

}
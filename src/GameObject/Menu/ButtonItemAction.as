package GameObject.Menu 
{
	import GameObject.Item.ItemStore;
	import GameObject.PlayableObject;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ButtonItemAction extends Button 
	{
		protected var m_itemStore:ItemStore;
		protected var m_text:FlxText;
		public function ButtonItemAction(itemStore:ItemStore, cursor:Cursor, player:PlayableObject, X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(cursor, player, X, Y, SimpleGraphic);
			m_width = 16;
			m_height = 16;
			
			m_itemStore = itemStore;
			m_text = new FlxText(this.x, this.y, m_width);
			m_text.text = m_itemStore.m_quantity.toString();
			m_text.size = 8;
			m_text.color = 0x000000;
		}
		
		override public function update() : void {
			super.update();
			m_text.text = m_itemStore.m_quantity.toString();
			m_text.x = this.x + 1;
			m_text.y = this.y + 3;
		}
		
		override public function validate() : void {
			m_player.m_itemManager.useItem(m_itemStore.getName());
			m_cursor.m_currentButton = m_cursor.m_firstButton;
			m_parent.hide();
		}
		
		override public function cancel() : void {
			super.cancel();
			m_parent.hide();
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.addElement(this, DepthBuffer.s_menuGroup);
			Global.currentState.depthBuffer.addElement(m_text, DepthBuffer.s_menuGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentState.depthBuffer.removeElement(this, DepthBuffer.s_menuGroup);
			Global.currentState.depthBuffer.removeElement(m_text, DepthBuffer.s_menuGroup);
		}
		
		override public function display() : void {
			super.display();
			m_text.visible = true;
		}
		
		override public function hide() : void {
			super.hide();
			m_text.visible = false;
		}
	}

}
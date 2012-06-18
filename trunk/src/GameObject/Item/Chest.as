package GameObject.Item 
{
	import GameObject.Converter;
	import GameObject.InteractiveObject;
	import GameObject.GameObject;
	import GameObject.Magic.Magic;
	import GameObject.Magic.MovableMagic;
	import GameObject.PlayableObject;
	import InfoObject.InfoCollected;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author ...
	 */
	public class Chest extends InteractiveObject
	{
		protected var m_item:Item;
		protected var m_quantity:int;
		protected var m_collected:Boolean;
		protected var m_new:Boolean;
		
		public function Chest( X:int, Y:int, item:String , quantity:int,collected:Boolean) 
		{
				super(X, Y);
				m_width = 24;
				m_height = 24;
				setHitboxInteract( -10, -10, m_width + 20, m_height + 20);
				m_url = "Images/Items/treasurechest.png";
				if(!collected){
					m_quantity = quantity;
					m_item = Converter.instantiateItem(item);
				}else {
					m_quantity = quantity;
					m_collected = true;
				}
		}
		
		override public function parseObject():void {
			m_parseObject.properties.collected = m_collected;
		}
		
		override public function addBitmap():void {
			super.addBitmap();
			if (m_collected)
				return;
			//if the item is new to the game
			if (!Global.library.getBitmap(m_item.m_url)) {
				//add Bitmaps for it
				m_new = true;
				m_item.addBitmap();
			}else {
				m_new = false;
			}
		}
		
		public function collect(player:PlayableObject) : void {
			player.addItem(m_item.m_name,m_quantity);
			m_collected = true;
			play("collected");
			//in order to free players at the next frame
			m_hasToFreePlayers = true;
			var item:InfoCollected = new InfoCollected(x, y,m_item.m_iconImage);
		}
		
		override public function load():void {
			super.load();
			addAnimation("idle", [0], 1, false);
			addAnimation("collected", [1], 1, false);
			if(!m_collected)
				play("idle");
			else
				play("collected");
		}
		
				
		override public function update() : void {
			if (m_collected) {
				if (m_hasToFreePlayers)
					freePlayers();	
				return;
			}
			//check Player 1
			if (canInteract(Global.player1)) {
				Global.cursorPlayer1.m_enabled = false;
				if (!m_collected) {
					if(FlxG.keys.justPressed(Global.player1.getButtonValidate())){
						collect(Global.player1);
					}
					
				}	
			}
			//check Player 2
			if(canInteract(Global.player2)){
				if (!m_collected){
					if(FlxG.keys.justPressed(Global.player2.getButtonValidate())){
						collect(Global.player2);
					}					
				}	
			}
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.addPhysical(element as PhysicalObject);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function removeFromStage():void {
			if (m_new && !m_collected) {
				Global.library.deleteBitmap(m_item.m_url);
				Global.library.deleteBitmap(m_item.m_iconImage);
			}
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
	}

}
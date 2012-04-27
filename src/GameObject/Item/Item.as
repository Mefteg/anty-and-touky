package GameObject.Item 
{
	import GameObject.DrawableObject;
	import GameObject.PhysicalObject;
	import GameObject.Stats;
	/**
	 * ...
	 * @author ...
	 */
	public class Item extends DrawableObject
	{
		public var m_caster:PhysicalObject;
		public var m_iconImage:String;
		public var m_statsEffect:Stats;
				
		public function Item( url:String = "",name:String=" ", width:int = 24, height:int = 32 ) 
		{ 
			m_typeName = "Item";
			m_width = width; m_height = height;
			m_name = name;
			m_statsEffect = Stats.EmptyStats();
			m_url = "Images/Items/itemrestore.png";
			m_iconImage = "Images/Menu/icon_rod_basic.png";
			m_state = "idle";
		}
		
		override public function addBitmap() : void{
			Global.library.addUniqueBitmap(m_url);
			Global.library.addUniqueBitmap(m_iconImage);
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.addPlayer(this);
		}
		
		override public function removeFromStage():void {
			Global.currentState.depthBuffer.removePlayer(this);
		}
		
		public function setAnimation(...rest):void {
			addAnimation("used", rest, 8, true);
		}
		
		public function addToMenu():void {
			/*if (!m_isPlayerCaster)
				return;
			if (m_caster.toString() == "Player1")
				Global.buttonMenuMagicPlayer1.addMagic(m_player.m_magics.length - 1);
			else
				Global.buttonMenuMagicPlayer2.addMagic(m_player.m_magics.length - 1);*/
		}
		
		public function useIt():void { }
		public function applyEffect():void{}
		
		
		///////////////////////////////////////////////////////////////////////
		//////////// PRBUILDED ITEMS TO RESTORE///////////////////////////////
		//////////////////////////////////////////////////////////////////////
		public static function Potion():ItemRestore {
			var potion:ItemRestore = new ItemRestore("Images/Items/itemrestore.png","potion",10, false, 32, 32);
			potion.setAnimation(0, 1, 2, 3, 4, 5, 6);
			potion.m_iconImage = "Images/Menu/icon_item_basic.png";
			return potion;
		}
	}

}
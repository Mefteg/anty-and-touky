package GameObject 
{
	import GameObject.Armor.Armor;
	import GameObject.Weapon.PlayerThrowable;
	import GameObject.Weapon.Sword;
	import GameObject.Weapon.Weapon;
	import GameObject.Weapon.Throwable;
	/**
	 * ...
	 * @author ...
	 */
	public class Equipement 
	{
		public var m_weapon:Sword;
		public var m_throwable:PlayerThrowable;
		public var m_armor:GameObject.Armor.Armor;
		
		public function Equipement() 
		{
			m_weapon = Sword.SwordBasic();
			m_throwable = PlayerThrowable.Slipper();
			m_armor = new GameObject.Armor.Armor();
		}
		
		public function addToLibrary():void {
			Global.library.addBitmap(m_weapon.m_url);
			Global.library.addBitmap(m_throwable.m_url);
		}
		
		public function addToStage():void {
		}
		
		public function load():void {
			m_weapon.load();
			m_throwable.load();
		}
		
	}

}
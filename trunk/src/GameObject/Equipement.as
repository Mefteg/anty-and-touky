package GameObject 
{
	import GameObject.Armor.Armor;
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
		public var m_throwable:Throwable;
		public var m_armor:GameObject.Armor.Armor;
		
		public function Equipement() 
		{
			m_weapon = Sword.SwordBasic();
			m_throwable = Throwable.Slipper();
			m_armor = new GameObject.Armor.Armor();
		}
		
		public function addToLibrary():void {
			Global.library.addBitmap(m_weapon.m_url);
			Global.library.addBitmap(m_throwable.m_url);
		}
		
		public function addToStage():void {
			m_weapon.addToStage();
		}
		
		public function load():void {
			m_weapon.load();
			m_throwable.load();
		}
		
	}

}
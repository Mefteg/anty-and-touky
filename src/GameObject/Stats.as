package GameObject 
{
	import GameObject.Magic.Elemental;
	/**
	 * ...
	 * @author Tom
	 */
	public class Stats 
	{
		public var m_hp_max:int;
		public var m_hp_current:int;
		public var m_mp_max:int;
		public var m_mp_current:int;
		
		public var m_attack_max:int;
		public var m_attack_current:int;
		
		public var m_magic_attack_max:int;
		public var m_magic_attack_current:int;
		
		public var m_defense_max:int;
		public var m_defense_current:int;
		
		public var m_magic_defense_max:int;
		public var m_magic_defense_current:int;
		
		public var m_elementalDefense:Elemental;
		
		public function Stats() 
		{
			m_hp_max = 25;
			m_hp_current = m_hp_max;
			m_mp_max = 25;
			m_mp_current = m_mp_max;
			m_attack_max = 10;
			m_attack_current = m_attack_max;
			m_magic_attack_max = 10;
			m_magic_attack_current = m_magic_attack_max;
			m_defense_max = 5;
			m_defense_current = m_defense_max;
			m_magic_defense_max = 5;
			m_magic_defense_current = m_magic_defense_max;
			m_elementalDefense = new GameObject.Magic.Elemental();
		}
		
		public function Reset():void {
			m_hp_max = 0;
			m_hp_current = 0;
			m_mp_max = 0;
			m_mp_current = 0;
			m_attack_max = 0;
			m_attack_current = 0;
			m_magic_attack_max = 0;
			m_magic_attack_current = 0;
			m_defense_max = 0;
			m_defense_current = 0;
			m_magic_defense_max = 0;
			m_magic_defense_current = 0;
		}
		
		public function initHP( hp:int) {
			m_hp_max = hp; m_hp_current = hp;
		}
		
		public function initMP( mp:int) {
			m_mp_max = mp; m_mp_current = mp;
		}
		
		public static function EmptyStats():GameObject.Stats {
			var stats:GameObject.Stats = new Stats();
			stats.Reset();
			return stats;
		}
	}

}
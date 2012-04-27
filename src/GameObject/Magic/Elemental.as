package GameObject.Magic 
{
	import adobe.utils.CustomActions;
	/**
	 * ...
	 * @author ...
	 */
	public class Elemental 
	{
		public var m_elementsStats:Object;
		private var m_nbDefenses:int = 0;
				
		public function Elemental() 
		{
			m_elementsStats = new Object();
		}
		
		public function setStats(...rest):void {
			for (var i:int = 0; i < rest[0].length; i++){
				m_elementsStats[[rest[0][i]]] = true;
				m_nbDefenses++;
			}
		}
		
		public function addStat(element:String) {
			m_elementsStats[element] = true;
			m_nbDefenses++;
		}
		
		public function deleteStat(element:String) {
			if (m_elementsStats[element]) {
				m_elementsStats = null;
				delete m_elementsStats[element];
				m_nbDefenses--;
			}
		}
		
		public function getDefenseRatio(elementalAttack:Elemental):Number {
			if (m_nbDefenses == 0)
				return 1.0;
			var ratio:Number = 0;
			var nbEffects:int = 0;
			var attacks:Object = elementalAttack.m_elementsStats;
			//for each elemental attack
			for (var attack:String in attacks) {
				var ratioLoc:Number = 0;
				var nbEffectsLoc:int = 0;
				//check all the defenses
				for(var defense:String in m_elementsStats){
					ratioLoc += Global.elementsTable[attack][defense];
					nbEffectsLoc++;
				}
				ratio += ratioLoc / nbEffectsLoc;
				nbEffects ++;
			}
			
			return ratio / nbEffects;
		}
	}

}
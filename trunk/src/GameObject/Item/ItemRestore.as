package GameObject.Item 
{
	import GameObject.DrawableObject;
	import GameObject.PlayableObject;
	import InfoObject.InfoDamage;
	/**
	 * ...
	 * @author ...
	 */
	public class ItemRestore extends Item
	{
		//ammount of HP/MP to be restored
		public var m_power:int;
		//tells if this is the HP that is to be restored (MP otherwise)
		public var m_hp:Boolean;
				
		public function ItemRestore(url:String,name:String,power:int, hp:Boolean,width:int,height:int) 
		{
			super(url,name, width, height);
			m_power = power;
			m_hp = hp;
		}
		
		override public function useIt():void {
			if (m_state != "idle")
				return;
			addToStage();
			play("used",true);
			m_state = "inUse";
		}
		
		override public function applyEffect():void {
			var col:uint;
			if (m_hp) {
				col = 0x00FF00;
				m_caster.m_stats.m_hp_current += m_power;
				if (m_caster.m_stats.m_hp_current > m_caster.m_stats.m_hp_max)
					m_caster.m_stats.m_hp_current = m_caster.m_stats.m_hp_max;
			}else {
				col = 0x00FFFF;
				m_caster.m_stats.m_mp_current += m_power;
				if (m_caster.m_stats.m_mp_current > m_caster.m_stats.m_mp_max)
					m_caster.m_stats.m_mp_current = m_caster.m_stats.m_mp_max;
			}
			var info:InfoDamage = new InfoDamage(x, y, String(m_power), col);
			info.addToStage();
		}
		
		override public function update():void {
			x = m_caster.x; y = m_caster.y;
			if (m_state == "inUse") {
				if (finished) {
					applyEffect();
					m_state = "idle";
					removeFromStage();
				}
			}
		}
		
	}

}
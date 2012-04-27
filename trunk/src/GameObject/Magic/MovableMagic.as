package GameObject.Magic 
{
	import GameObject.MovableObject;
	import GameObject.PlayableObject;
	/**
	 * ...
	 * @author Moi
	 */
	public class MovableMagic extends Magic
	{
		
		public function MovableMagic( power:int, url:String = "",widt:int=24,height:int=32) 
		{
			super(power,url,widt,height);
		}
		
		override public function attack():void 
		{
			super.attack();
			
			if (m_caster.facing == UP){ 
				m_direction.y = -1;
			}else if (m_caster.facing == DOWN){
				m_direction.y = 1;
			} else	if (m_caster.facing == LEFT){
				m_direction.x = -1;
			}else if (m_caster.facing == RIGHT){
				m_direction.x = 1;
			}
			
			move();
		}
		
		override public function update():void {
			//don't update if not visible ie not active
			if (m_state == "attack") {
				if (m_linked && m_timerAction.finished) {
					FreeCaster();
				}
				
				if(!onScreen()){
					touched();
					return;
				}
				//check if the magic can deal damage
				if (m_timerHit.finished) {
					//check damage
					if (CheckDamageDealt()) {
						m_shotsCount++;
						if (m_shotsCount >= m_shotsMax) {
							touched();
						}else {
							m_timerHit.start(m_timeHit);
						}
					}
				}
				move();
			}
		}
	}

}
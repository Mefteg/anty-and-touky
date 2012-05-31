package GameObject.Other 
{
	import GameObject.InteractiveObject;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Breakable extends InteractiveObject 
	{
		
		public function Breakable(X:Number, Y:Number ) 
		{
			super(X, Y);
			m_state = "idle";
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_objectGroup);
		}
		
		public function setIdleAnim(...rest):void {
			addAnimation("idle", rest, 0, true);
		}
		
		public function setBreakAnim(...rest):void {
			addAnimation("breaking", rest, 10, false);
		}
		
		public function setBrokenAnim(...rest):void {
			addAnimation("broken", rest, 0, true);
		}
		
		override public function update():void {
			switch(m_state) {
				case "idle" : if (canInteract(Global.player1) && Global.player1.isRushing()) {
								m_state = "breaking";
								Global.player1.unspecial();
								play("breaking");
							}
							break;
				case "breaking": if (finished){
									m_state = "broken";
									m_canGoThrough = true;
									play("broken");
								}
								break;
				default:break;
			}
			
		}
		
		///////////PREBUILDED BREAKABLES///////////////:
		
		public static function Rock(X:Number,Y:Number):Breakable {
			var rock:Breakable = new Breakable(X, Y);
			rock.m_url = "Images/Others/breakable_rock.png";
			rock.m_width = 48; rock.m_height = 48;
			rock.setHitbox(0, 0, 48, 48);
			rock.setIdleAnim(0);
			rock.setBreakAnim(1, 2, 3, 4, 5, 6, 7, 8);
			rock.setBrokenAnim(9);
			return rock;
		}
		
	}

}
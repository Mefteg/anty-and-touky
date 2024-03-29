package GameObject.Other 
{
	import GameObject.InteractiveObject;
	import GameObject.Item.SpecialFiller;
	import org.flixel.FlxSound;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Breakable extends InteractiveObject 
	{
		private var m_FX:FlxSound;
		public var m_FXurl:String = "FX/rock_explode.mp3";
		private var item:SpecialFiller;
		
		public function Breakable(X:Number, Y:Number ) 
		{
			super(X, Y);
			m_state = "idle";
			m_FX = new FlxSound();
			m_bufferGroup = DepthBufferPlaystate.s_objectGroupFG;
			m_typeName = "Breakable";
			m_width = 48; m_height = 48;
			setHitbox(0, 0, 48, 48);
			item = SpecialFiller.GoldAnt(0,0);
		}
		
		override public function load():void {
			super.load();
			m_FX.loadStream(m_FXurl);
			item.load();
			if(Global.nbPlayers >1)
				m_hitboxInteraction = new Hitbox(m_hitbox.x - 50,m_hitbox.y - 50, m_hitbox.width + 63,m_hitbox.height + 63);
		}
		
		override public function addToStage():void {
			super.addToStage();
			Global.currentPlaystate.addPhysical(this);
		}
		
		override public function addBitmap():void {
			super.addBitmap();
			item.addBitmap();
		}
		
		override public function removeFromStage():void {
			super.removeFromStage();
			Global.currentPlaystate.removePhysical(this);
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
				case "idle" : if (Global.player1.isRushing() && ( canInteract(Global.player1) || canInteract(Global.player2) ) ) {
								m_state = "breaking";
								Global.player1.unspecial();
								play("breaking");
								m_FX.play();
							}
							break;
				case "breaking": if (finished){
									m_state = "broken";
									m_collideWithObjects = false;
									play("broken");
									//item.place(x +10 , y+10);
									//item.addToStage();
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
			rock.m_FXurl = "FX/rock_explode.mp3";
			return rock;
		}
		
		public static function ExplosiveBarrel(X:Number, Y:Number):Breakable {
			var barr:Breakable = new Breakable(X, Y);
			barr.m_url = "Images/Others/breakable_barrel.png";
			barr.setIdleAnim(0);
			barr.setBreakAnim( 4, 5, 6, 7, 8,9,10,11);
			barr.setBrokenAnim(1);
			barr.m_FXurl = "FX/rock_explode.mp3";
			return barr;
		}
	}

}
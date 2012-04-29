package GameObject.Weapon 
{
	import GameObject.DrawableObject;
	import GameObject.MovableObject;
	import GameObject.PhysicalObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	/**
	 * ...
	 * @author ...
	 */
	public class Weapon extends PhysicalObject
	{
		//time to be hit again by the weapon
		public var m_timeAction:Number;
		
		public var m_power:Number;
		
		public var m_FXurl:String;
		public var m_FX:FlxSound;
		
		public function Weapon( power:Number , url:String, urlSound:String = "FX/swipe.mp3" ) 
		{
			super(0, 0, null);
			m_typeName = "Weapon";
			m_url = url;
			m_power = power;
			m_width = 24;
			m_height = 24;
			m_timeAction = 1;
			m_FXurl = urlSound;
			m_FX = new FlxSound();
		}
		
		public function attack(direction:int):void {
			m_FX.play();
			m_state = "attack";
			play("attack" + direction);
			addToStage();
		}
		
		public function place(newX:Number, newY:Number ):void {
			x = newX; y = newY;
		}
		
		override public function addToStage():void {
			Global.currentState.depthBuffer.addNonPhysicalPlayer(this);
		}
		
		override public function removeFromStage():void {
			Global.currentState.depthBuffer.removeNonPhysicalPlayer(this);
		}
		
		public function Idleize() : void {
			m_state = "idle";
			play("idle" + facing);
			removeFromStage();
		}
		public function isAttacking():Boolean {
			return m_state = "attack";
		}
		public function isInAttackState():Boolean {
			return m_state = "attack";
		}		
		
	}

}
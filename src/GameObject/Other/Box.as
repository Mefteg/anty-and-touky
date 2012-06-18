package GameObject.Other 
{
	import GameObject.DrawableObject;
	import GameObject.InteractiveObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Box extends DrawableObject 
	{
		public var m_offset:FlxPoint;
		
		public function Box(X:Number,Y:Number ) 
		{
			super(X, Y);
			m_state = "idle";
			m_name = "Box";
			m_url = "Images/Others/box.png";
			m_width = 32; m_height = 32;
			m_offset = new FlxPoint(10, 34);
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.addBox(this);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_foregroundGroup);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.removeBox(this);
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_foregroundGroup);
		}
		
		override public function place(newX:Number, newY:Number):void {
			x = Global.player2.x + m_offset.x; y = Global.player2.y + m_offset.y;
		}
		
		override public function act():void {
			var holes:Vector.<BoxHole> = Global.currentPlaystate.m_holeboxes;
			var goodHole:BoxHole;
			for (var i:int = 0; i < holes.length; i++) {
				if (collide(holes[i]) ){
					goodHole = holes[i];
					break;
				}
			}
			if (goodHole){
				goodHole.act();
				x = goodHole.x; y = goodHole.y;
				Global.currentPlaystate.removeBox(this);
			}
		}
		
		override public function update():void {
		}
		
		public function take():void {
			m_state = "taken";
		}
		
	}

}
package GameObject.Other 
{
	import GameObject.DrawableObject;
	import GameObject.Enemy.EnemySmoke;
	import GameObject.InteractiveObject;
	import GameObject.Tile.Hole;
	import GameObject.TileObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Box extends DrawableObject 
	{
		public var m_offset:FlxPoint;
		public var m_initPos:FlxPoint;
		
		private var m_smokeDestroy:EnemySmoke;
		
		public function Box(X:Number,Y:Number ) 
		{
			super(X, Y);
			m_state = "idle";
			m_name = "Box";
			m_url = "Images/Others/box.png";
			m_width = 32; m_height = 32;
			m_offset = new FlxPoint(10, 34);
			m_initPos = new FlxPoint(X, Y);
			m_smokeDestroy = EnemySmoke.PlayerSmoke();
		}
		
		override public function addBitmap():void {
			super.addBitmap();
			m_smokeDestroy.addBitmap();
		}
		
		override public function load():void {
			super.load();
			m_smokeDestroy.load();
		}
		
		override public function addToStage():void {
			Global.currentPlaystate.addBox(this);
			Global.currentPlaystate.depthBuffer.addElement(this, DepthBufferPlaystate.s_objectGroupFG);
		}
		
		override public function removeFromStage():void {
			Global.currentPlaystate.removeBox(this);
			Global.currentPlaystate.depthBuffer.removeElement(this, DepthBufferPlaystate.s_objectGroupFG);
		}
		
		override public function place(newX:Number, newY:Number):void {
			x = Global.player2.x + m_offset.x; y = Global.player2.y + m_offset.y;
		}
		
		override public function act():void {
			//check if the player is not on a hole
			var tiles:Array = Global.player2.tilesUnder();
			for each (var tile:TileObject in tiles) {
				if (tile.m_typeName == Hole.s_type) {
					respawn();
					return;
				}
			}
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
			if (m_state == "respawning") {
				if (m_smokeDestroy.finished) {
					m_state = "idle";
					m_smokeDestroy.playSmoke(x, y);
					visible = true;
				}
			}
		}
		
		override public function respawn():void {
			m_smokeDestroy.playSmoke(x, y);
			m_state = "respawning";
			x = m_initPos.x;
			y = m_initPos.y;
			visible = false;
		}
				
		public function take():void {
			m_state = "taken";
		}
		
		public static function Barrel(X:Number,Y:Number):Box {
			var barrel:Box = new Box(X, Y);
			barrel.m_url = "Images/Others/barrel.png";
			return barrel;
		}
		
	}

}
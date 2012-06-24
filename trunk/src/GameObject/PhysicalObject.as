package GameObject 
{
	import flash.display.Scene;
	import flash.sampler.NewObjectSample;
	import GameObject.Tile.Foreground;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import Scene.Scene;
	/**
	 * ...
	 * @author Tom
	 */
	public class PhysicalObject extends MovableObject 
	{
		public var m_stats:GameObject.Stats;
		public var m_canGoThrough:Boolean = false;
		public var m_collideWithObjects = true;
		public var m_weight:int = 10;
		public var m_pushed:Boolean = false;
		
		public function PhysicalObject(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_collide = true;
		}
		
		override public function update() : void {
			super.update();
			
			//m_canGoThrough = true;
		}
				
		override public function move() : void {
			m_canGoThrough = true;
			super.move();
				
			// if the new position involves an environment collision
			if ( this.collideWithEnv() ) {
				// keep the current position
				this.x = m_oldPos.x;
				this.y = m_oldPos.y;
			}
		}
		
		/**
		 * Compute the collision with the environment
		 * @return true if the object is colliding with the environment
		 */
		public function collideWithEnv() : Boolean {
			var scene:Scene.Scene = Global.currentPlaystate.getCurrentScene();
			// if the new position involves an environment collision
			if ( this.collideWithTiles(scene.tilesBackground, 0) || this.collideWithTiles(scene.tilesForeground, 1) ) {
				return true;
			}
			else {
				return false;
			}
		}
		
		/**
		 * Compute the collision with the environment
		 * @param env	the array containing tiles ( Background or Foreground )
		 * @return true if the object is colliding with the tiles
		 */
		public function collideWithTiles(env:Array, id:int=0) : Boolean {
			var collide:Boolean = false;
			
			// if the scene has been loaded
			if ( Global.currentPlaystate.sceneManager.isLoadComplete() ) {
				var tiles:Array = new Array();
				
				// get the top left corner of the object
				var topleft:FlxPoint = new FlxPoint(this.x + m_hitbox.x, this.y + m_hitbox.y);
				// get the bottom right corner of the object
				var bottomright:FlxPoint = new FlxPoint(topleft.x + m_hitbox.width, topleft.y + m_hitbox.height);
				
				// convert them for the grid
				var topleftToGrid:FlxPoint = new FlxPoint(int(topleft.x/Global.tile_width), int(topleft.y/Global.tile_height));
				var bottomrightToGrid:FlxPoint = new FlxPoint(int(bottomright.x / Global.tile_width), int(bottomright.y / Global.tile_height));
				
				// for each tile under the object
				for ( var i:int = topleftToGrid.x; i <= bottomrightToGrid.x; i++ ) {
					for ( var j:int = topleftToGrid.y; j <= bottomrightToGrid.y; j++ ) {
						var index:uint = j * Global.nb_tiles_width + i;
						var tile:GameObject.TileObject = env[index];
						tiles.push(tile);

						if ( id == 1 && tile.m_typeName == GameObject.PhysicalTile.s_type ) {
							//trace(tile.m_typeName + " collide : " + tile.m_collide);
						}
						
						// if the tile is physical
						/*if ( tile.m_collide == true ) {
							collide = true;
						}*/
						if ( tile.collideWith(this) ) {
							collide = true;
						}
					}
				}
			}
			
			return collide;
		}
	}

}
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
		public var m_collideEvtFree:Boolean = false;
		
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
				var newPos:FlxPoint = new FlxPoint(this.x, this.y);
				
				this.y = m_oldPos.y;
				// if the collision is on the x axis
				if ( !m_collideEvtFree && this.collideWithEnv() ) {
					this.x = m_oldPos.x;
				}
				
				this.y = newPos.y;
				// if the collision is also on the y axis
				if ( !m_collideEvtFree && this.collideWithEnv() ) {
					this.y = m_oldPos.y;
				}
			}
		}
		
		/**
		 * Compute the collision with the environment
		 * @return true if the object is colliding with the environment
		 */
		public function collideWithEnv() : Boolean {
			var collide:Boolean = false;
			
			// if the new position involves an environment collision
			if ( this.collideWithTiles(this.tilesUnder()) || this.collideWithTiles(this.tilesOver()) )
			{
				collide = true;
			}
			
			return collide;
		}
		
		/**
		 * Compute the collision with the environment
		 * @param env	the array containing tiles ( Background or Foreground )
		 * @return true if the object is colliding with the tiles
		 */
		public function collideWithTiles(_env:Array) : Boolean {
			var collide:Boolean = false;
			
			// if the scene has been loaded
			if ( Global.currentPlaystate.sceneManager.isLoadComplete() ) {
				// for each tile under the object
				for ( var i:int = 0; i < _env.length; i++ ) {					
					// if the tile is physical
					if ( this.collideWithTileType(_env[i]) == true )
					{
						collide = true;
					}
				}
			}
			
			return collide;
		}
		
		public	function collideWithTileType(_type:int) : Boolean
		{
			var collide:Boolean = false;
			
			if (
			_type == TilesManager.PHYSICAL_TILE ||
			_type == TilesManager.HOLE_TILE ||
			_type == TilesManager.PIPE_TILE
			)
			{
				collide = true;
			}
			
			return collide;
		}
		
		public function tilesUnder() : Array 
		{
			var tilesManager:TilesManager = Global.tilesManager;
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
					var index:int = j * Global.nb_tiles_width + i;
					var type:int = tilesManager.getTileType(0, index);
					tiles.push(type);
				}
			}
			
			return tiles;
		}
	
		public function tilesOver() : Array 
		{
			var tilesManager:TilesManager = Global.tilesManager;
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
					var index:int = j * Global.nb_tiles_width + i;
					var type:int = tilesManager.getTileType(1, index);
					tiles.push(type);
				}
			}
			
			return tiles;
		}
		
		public function replaceWithNoCollision() : void 
		{
			var didCollide:Boolean = true;
			while (didCollide) {
				didCollide = false;
				var tilesManager:TilesManager = Global.tilesManager;
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
						var index:int = j * Global.nb_tiles_width + i;
						var type:int = tilesManager.getTileType(0, index);
							if (type == TilesManager.PHYSICAL_TILE) {
								didCollide = true;
								var xTile:int = i * 32;
								var yTile:int = j * 32;
								//if the object is colliding from the left
								if (x < xTile)
									x = xTile - m_width;
								//else
								else
									x = xTile + 32;
								//if the object is colliding from the top
								if (y < yTile)
									y = yTile - m_height;
								//else
								else
									y = yTile + 32 - m_hitbox.y;
							}
					}
				}
							
				// for each tile top of the object
				for ( var i:int = topleftToGrid.x; i <= bottomrightToGrid.x; i++ ) {
					for ( var j:int = topleftToGrid.y; j <= bottomrightToGrid.y; j++ ) {
						var index:int = j * Global.nb_tiles_width + i;
						var type:int = tilesManager.getTileType(1, index);
						if (type == TilesManager.PHYSICAL_TILE) {
							didCollide = true;
							var xTile:int = i * 32;
							var yTile:int = j * 32;
							//if the object is colliding from the left
							if (x < xTile)
								x = xTile - m_width;
							//else
							else
								x = xTile + 32;
							//if the object is colliding from the left
							if (y < yTile)
								y = yTile - m_height;
							//else
							else
								y = yTile + 32 - m_hitbox.y;
						}
					}
				}
			}
			
		}
	}
}
package GameObject 
{
	/**
	 * ...
	 * @author ...
	 */
	import GameObject.Enemy.BlackSquare;
	import GameObject.Enemy.Slime;
	import GameObject.Enemy.WhiteSquare;
	import GameObject.Item.Chest;
	import GameObject.Item.Item;
	import GameObject.Player.Player1;
	import GameObject.Player.Player2;
	import GameObject.Tile.Foreground;
	import GameObject.Trigger.TriggerCutScene;
	import GameObject.Trigger.TriggerWarp;
	import GameObject.Tile.Grass;
	import GameObject.Tile.Rock;
	import org.flixel.FlxPoint;
	import Scene.CutScene.CutScene;
	
	public class Converter 
	{
		public static var m_tabItems:Object = {
			"potion": Item.Potion			
		}
		
		static public function convertJsonObject(object:Object) : GameObject {	
			
			switch(object.type) {
				//enemies
				case "Slime" : var m_gobj:MovableObject = new GameObject.Enemy.Slime(object.x, object.y);
								if (object.properties.blocked != null)
									m_gobj.block();
								m_gobj.m_name = object.name;
								return m_gobj; break;
				case "WhiteSquare":  return new GameObject.Enemy.WhiteSquare(object.x, object.y); break;
				case "BlackSquare":  return new GameObject.Enemy.BlackSquare(object.x, object.y); break;
				//items
				case "Chest" : return new GameObject.Item.Chest(object.x, object.y,object.properties.item,object.properties.quantity,object.properties.collected); break;
				//triggers
				case "TriggerWarp": return new GameObject.Trigger.TriggerWarp(object.x, object.y, null,object.properties.url,object.properties.respawn, object.width, object.height); break;
				case "TriggerCutScene": return new TriggerCutScene(object.x, object.y, object.width, object.height, object.properties.url); break;
				default:  return new GameObject.Enemy.WhiteSquare(object.x, object.y); break;
			}
			return null;
		}
		
		static public function convertJsonTile(type:String, pos:FlxPoint, mapName:String, tileId:uint) : GameObject.DrawableObject{
			switch(type) {
				case "Grass":  return new GameObject.Tile.Grass(pos.x, pos.y, mapName, tileId); break;
				case "Rock":  return new GameObject.Tile.Rock(pos.x, pos.y, mapName, tileId); break;
				case "PhysicalTile":  return new GameObject.PhysicalTile(pos.x, pos.y, mapName, tileId); break;
				case "Foreground":  return new GameObject.Tile.Foreground(pos.x, pos.y, mapName, tileId); break;
				default:  return new GameObject.TileObject(pos.x, pos.y, mapName, tileId); break;
			}
			return null;
		}
		
		static public function instantiateItem(name:String):Item {
			return m_tabItems[name]();
		}
		
	}

}
package GameObject 
{
	/**
	 * ...
	 * @author ...
	 */
	import GameObject.Enemy.BlackSquare;
	import GameObject.Enemy.Centipede.Centipede;
	import GameObject.Enemy.Monkey;
	import GameObject.Enemy.MonkeyTest;
	import GameObject.Enemy.Penguin;
	import GameObject.Enemy.PenguinJetpack;
	import GameObject.Enemy.Slime;
	import GameObject.Enemy.WhiteSquare;
	import GameObject.Item.Chest;
	import GameObject.Item.Item;
	import GameObject.Other.Breakable;
	import GameObject.Player.Player1;
	import GameObject.Player.Player2;
	import GameObject.Tile.Foreground;
	import GameObject.Tile.Hole;
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
				case "Monkey": return new GameObject.Enemy.Monkey(object.x, object.y); break;
				case "Penguin" : return new Penguin(object.x, object.y); break;
				case "PenguinJetpack" : return new PenguinJetpack(object.x, object.y); break;
				case "Centipede" : return new Centipede(object.x, object.y); break;
				case "MonkeyTest": return new GameObject.Enemy.MonkeyTest(object.x,object.y); break;
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
				//other
				case "BreakableRock" : return Breakable.Rock(object.x, object.y); break;
				
				default:  return new GameObject.Enemy.WhiteSquare(object.x, object.y); break;
				
			}
			return null;
		}
		
		static public function convertJsonTile(layer:uint, type:String, pos:FlxPoint, mapName:String, tileId:uint) : GameObject.DrawableObject{
			switch(type) {
			case Grass.s_type:  return new GameObject.Tile.Grass(layer, pos.x, pos.y, mapName, tileId); break;
			case Rock.s_type:  return new GameObject.Tile.Rock(layer, pos.x, pos.y, mapName, tileId); break;
			case Hole.s_type:  return new Hole(layer, pos.x, pos.y, mapName, tileId); break;
			case PhysicalTile.s_type:  return new GameObject.PhysicalTile(layer, pos.x, pos.y, mapName, tileId); break;
			case Foreground.s_type:  return new GameObject.Tile.Foreground(pos.x, pos.y, mapName, tileId); break;
		default:
			if ( layer == 0 )
				return new GameObject.TileObject(layer, pos.x, pos.y, mapName, tileId);
			else
				return new GameObject.TileObject(layer, pos.x, pos.y, mapName, 0); // empty slot
				break;
			}
			return null;
		}
		
		static public function instantiateItem(name:String):Item {
			return m_tabItems[name]();
		}
		
	}

}
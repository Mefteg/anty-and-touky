package GameObject 
{
	/**
	 * ...
	 * @author ...
	 */
	import GameObject.Enemy.BlackSquare;
	import GameObject.Enemy.Cannon;
	import GameObject.Enemy.Centipede.Centipede;
	import GameObject.Enemy.ElectricSnake.ElectricSnake;
	import GameObject.Enemy.ElSqualo.ElSqualo;
	import GameObject.Enemy.Monkey;
	import GameObject.Enemy.MonkeyTest;
	import GameObject.Enemy.Penguin;
	import GameObject.Enemy.PenguinJetpack;
	import GameObject.Enemy.Slime;
	import GameObject.Enemy.WhiteSquare;
	import GameObject.Item.Chest;
	import GameObject.Item.Item;
	import GameObject.Item.SpecialFiller;
	import GameObject.Other.AnimatedObject;
	import GameObject.Other.Box;
	import GameObject.Other.BoxHole;
	import GameObject.Other.Breakable;
	import GameObject.Other.Butterfly;
	import GameObject.Other.Door;
	import GameObject.Other.Generator;
	import GameObject.Other.NPC;
	import GameObject.Other.Switch;
	import GameObject.Player.Player1;
	import GameObject.Player.Player2;
	import GameObject.Tile.Foreground;
	import GameObject.Tile.Hole;
	import GameObject.Trigger.TriggerCutScene;
	import GameObject.Trigger.TriggerEnemies;
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
				case "PenguinScientist": return Penguin.Scientist(object.x, object.y); break;
				case "PenguinJetpack" : return new PenguinJetpack(object.x, object.y); break;
				case "WaterPenguin" : return new GameObject.Enemy.PenguinWater(object.x, object.y); break;
				case "Centipede" : return new Centipede(object.x, object.y,object.width,object.height); break;
				case "MonkeyTest": return new GameObject.Enemy.MonkeyTest(object.x,object.y); break;
				case "ElectricSnake": return new ElectricSnake(object.x, object.y); break;
				case "Cannon" : return new Cannon(object.x, object.y,object.properties.lift); break;
				case "WhiteSquare":  return new GameObject.Enemy.WhiteSquare(object.x, object.y); break;
				case "BlackSquare":  return new GameObject.Enemy.BlackSquare(object.x, object.y); break;
				case "TriggerEnemies": return new TriggerEnemies(object); break;
				case "ElSqualo" : return new ElSqualo(object.x, object.y, object.width, object.height); break;
				//NPC
				case "Raccoon" : return NPC.Raccoon(object.x, object.y, object.properties.url); break;
				case "MexicanRaccoon" : return NPC.MexicanRaccoon(object.x, object.y,object.properties.url); break;
				//items
				case "Chest" : return new GameObject.Item.Chest(object.x, object.y,object.properties.item,object.properties.quantity,object.properties.collected); break;
				case "Box": return new GameObject.Other.Box(object.x, object.y); break;
				case "Barrel" : return Box.Barrel(object.x, object.y); break;
				case "BoxHole": return new GameObject.Other.BoxHole(object.x, object.y, object.properties.door); break;
				case "BarrelHole" : return BoxHole.BarrelHole(object.x, object.y, object.properties.door); break;
				case "GoldFeather" : return SpecialFiller.GoldFeather(object.x, object.y); break;
				///DOORS
				case "Spikes" : return new Door(object.x, object.y, object.name, object.properties.respawn); break;
				case "Cylinders" : return Door.Cylinders(object.x, object.y, object.name,object.properties.respawn); break;
				case "Switch": return new Switch(object.x, object.y, object.properties.door, object.properties.time); break;
				case "SwitchMetal": return Switch.SwitchMetal(object.x, object.y, object.properties.door, object.properties.time); break;
				case "ElectricDoor" : return Door.ElectricDoor(object.x, object.y, object.name, object.properties.respawn); break;
				//triggers
				case "TriggerWarp": return new GameObject.Trigger.TriggerWarp(object.x, object.y, null,object.properties.url,object.properties.respawn, object.width, object.height); break;
				case "TriggerCutScene": return new TriggerCutScene(object.x, object.y, object.width, object.height, object.properties.url); break;
				//other
				case "BreakableRock" : return Breakable.Rock(object.x, object.y); break;
				case "Butterfly" : return new Butterfly(object.x, object.y); break;
				case "FallenResetChecker": return new GameObject.Other.FallenResetChecker(object.x, object.y); break;
				case "Generator" : return new Generator(object.x, object.y, object.properties.door); break;
				case "Lift" : return new GameObject.Other.Lift(object.x, object.y, object.properties.range); break;
				case "HorizontalPillar" : return new GameObject.Other.HorizontalPillar(object); break;
				//animated objects
				case "Alarm" : return AnimatedObject.Alarm(object.x, object.y); break;
				
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
			//case Foreground.s_type:  return new GameObject.Tile.Foreground(pos.x, pos.y, mapName, tileId); break;
		default:
			if ( layer == 0 ) {
				return new GameObject.TileObject(layer, pos.x, pos.y, mapName, tileId);
			}
			else {
				return new GameObject.TileObject(layer, pos.x, pos.y, mapName, tileId); // empty slot
			}
				break;
			}
			return null;
		}
		
		static public function instantiateItem(name:String):Item {
			return m_tabItems[name]();
		}
		
	}

}
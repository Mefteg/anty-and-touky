package GameObject.Enemy.ElSqualo 
{
	import GameObject.Enemy.PenguinJetpack;
	import GameObject.GameObject;
	import GameObject.MovableObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ElSqualoPenguinManager extends GameObject 
	{
		private var m_pinguins:Array;
		private var m_squalo:ElSqualo;
		private var m_nbPg:int;
		
		public function ElSqualoPenguinManager(squalo:ElSqualo) 
		{
			m_pinguins = new Array();
			createPinguins();
			m_squalo = squalo;
		}
		
		private function putAtRandomPosition(pg:PenguinJetpack):void {
			var rand:Number = Utils.random(0, 100);
			var ordinees:Number = Global.camera.scroll.y + Utils.random(10, m_squalo.m_area.height);
			if (rand<50) {
				var pgx:Number = Global.camera.scroll.x;
				pg.init(pgx, ordinees);
				pg.m_direction = new FlxPoint(1, 0);
			}else {
				var pgx:Number = Global.camera.scroll.x + Global.camera.width;
				pg.init(pgx, ordinees);
				pg.m_direction = new FlxPoint(-1, 0);
			}
		}
		
		override public function update():void {
			/*for (var i:int = 0; i < m_nbPg; i++)
				m_pinguins[i].move();*/
		}
		
		///PINGINS .....
		
		private function createPinguins():void {
			for (var i:int = 0; i < 4 ; i++)
				m_pinguins.push(new PenguinJetpack(0, 0));
		}
		
		public function popPinguins(nbPing:int = 1):void {
			m_nbPg = nbPing;
			for (var i:int = 0; i < nbPing; i++) {
				putAtRandomPosition(m_pinguins[i]);
			}
		}
		
		override public function load():void {
			for (var i:int = 0; i < m_pinguins.length; i++)
				m_pinguins[i].load();
		}
		
		override public function addBitmap():void {
			m_pinguins[0].addBitmap();
		}
		
		
	}

}
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
		private var m_pinguinsDone:Array;
		
		public function ElSqualoPenguinManager(squalo:ElSqualo) 
		{
			m_pinguins = new Array();
			createPinguins();
			m_squalo = squalo;
			m_state = "idle";
		}
		
		private function putAtRandomPosition(pg:PenguinJetpack):void {
			var rand:Number = Utils.random(0, 100);
			var ordinees:Number = m_squalo.m_area.y + Utils.random(10, m_squalo.m_area.height-10);
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
		
		public function blam():void {
			for (var i:int = 0; i < m_pinguins.length; i++)
				m_pinguins[i].explode();
		}
		
		override public function update():void {
			switch(m_state){
				case "moving" : var boo:Boolean = true;
								for (var i:int = 0; i < m_nbPg; i++) {
									if (m_pinguinsDone[i]) {
										boo = boo && true;
										return;
									}
									m_pinguins[i].move();
									if (m_squalo.m_area.containsRect(m_pinguins[i].getHitboxRect())) {
										boo = boo && true;
										m_pinguins[i].activate();
									}else {
										boo = false;
									}
								}
								if (boo)
									m_state = "idle";
								break;
			}
		}
		
		///PINGINS .....
		
		private function createPinguins():void {
			for (var i:int = 0; i < 6 ; i++)
				m_pinguins.push(new PenguinJetpack(0, 0));
		}
		
		public function popPinguins(nbPing:int = 1):void {
			m_state = "moving";
			m_nbPg = nbPing;
			for (var i:int = 0; i < m_nbPg; i++) {
				m_pinguins[i].removeFromStage();
				m_pinguins[i] = new PenguinJetpack(0, 0);
				m_pinguins[i].load();
				putAtRandomPosition(m_pinguins[i]);
			}
			initPDone();
		}
		
		override public function load():void {
			for (var i:int = 0; i < m_pinguins.length; i++)
				m_pinguins[i].load();
		}
		
		override public function addBitmap():void {
			m_pinguins[0].addBitmap();
		}
		
		private function initPDone():void {
			m_pinguinsDone = new Array();
			for (var i:int = 0; i < m_nbPg; i++)
				m_pinguinsDone.push(false);
		}
		
	}

}
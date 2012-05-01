package GameObject 
{
	import adobe.utils.CustomActions;
	import flash.geom.ColorTransform;
	import org.flixel.*;
	/**
	 * ...
	 * @author Tom
	 */
	public class DrawableObject extends GameObject 
	{		
		protected var _twinkleOn:Boolean = false;
		protected var _twinkleHit:uint = 0xFF8000;
		protected var _twinkleRestore:uint = 0x00FF00;
		protected var _twinkleColor:uint;
		public var m_timerTwinkle:FlxTimer;
		
		public function DrawableObject(X:Number=0, Y:Number=0, SimpleGraphic:Class=null) 
		{
			super(X, Y, SimpleGraphic);
			m_typeName = "Drawable";
			this.visible = true;
			_twinkleColor = _twinkleHit;
			m_timerTwinkle = new FlxTimer();
			facing = RIGHT;
		}
		
		override public function addBitmap():void {
			Global.library.addBitmap(m_url);
		}
		
		override public function deleteBitmap():void {
			Global.library.deleteBitmap(m_url);
		}
		
		override public function load() : void{
			loadGraphic2(Global.library.getBitmap(m_url), true, false, m_width, m_height);
			if (!m_hitbox)
				setHitbox(0, 0, m_width, m_height);
		}
		
		public function changeTwinkleColor(Color:uint) {
			_twinkleColor = Color;
		}
		public function unFlashColor():void
        {
            _colorTransform = null;
            calcFrame();
        }

        public function flashColor(Color:uint):void
        {
            _colorTransform = new ColorTransform();
            _colorTransform.color = Color;
            calcFrame();
        }
		
		public function twinkle():void {
			if (m_timerTwinkle.finished)
				return;
				
			if (m_timerTwinkle.progress > 0.9){
				unFlashColor();
				_twinkleOn = false;
			}else{
				if( ! _twinkleOn && m_timerTwinkle.progress <0.1){
					flashColor(_twinkleColor);
					_twinkleOn = true;
				}else if ( _twinkleOn && ( m_timerTwinkle.progress > 0.3 && m_timerTwinkle.progress < 0.6 )){
					unFlashColor();
					_twinkleOn = false;
				}else if (!_twinkleOn && m_timerTwinkle.progress > 0.6) {
					flashColor(_twinkleColor);
					_twinkleOn = true;
				}
			}
		}
	}

}
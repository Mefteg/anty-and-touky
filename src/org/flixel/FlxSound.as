package org.flixel
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * This is the universal flixel sound object, used for streaming, music, and sound effects.
	 * 
	 * @author	Adam Atomic
	 */
	public class FlxSound extends FlxBasic
	{
		/**
		 * The X position of this sound in world coordinates.
		 * Only really matters if you are doing proximity/panning stuff.
		 */
		public var x:Number;
		/**
		 * The Y position of this sound in world coordinates.
		 * Only really matters if you are doing proximity/panning stuff.
		 */
		public var y:Number;
		/**
		 * Whether or not this sound should be automatically destroyed when you switch states.
		 */
		public var survive:Boolean;
		/**
		 * The ID3 song name.  Defaults to null.  Currently only works for streamed sounds.
		 */
		public var name:String;
		/**
		 * The ID3 artist name.  Defaults to null.  Currently only works for streamed sounds.
		 */
		public var artist:String;
		/**
		 * Stores the average wave amplitude of both stereo channels
		 */
		public var amplitude:Number;
		/**
		 * Just the amplitude of the left stereo channel
		 */
		public var amplitudeLeft:Number;
		/**
		 * Just the amplitude of the left stereo channel
		 */
		public var amplitudeRight:Number;
		/**
		 * Whether to call destroy() when the sound has finished.
		 */
		public var autoDestroy:Boolean;

		/**
		 * Internal tracker for a Flash sound object.
		 */
		protected var _sound:Sound;
		/**
		 * Internal tracker for a Flash sound channel object.
		 */
		protected var _channel:SoundChannel;
		/**
		 * Internal tracker for a Flash sound transform object.
		 */
		protected var _transform:SoundTransform;
		/**
		 * Internal tracker for the position in runtime of the music playback.
		 */
		protected var _position:Number;
		/**
		 * Internal tracker for how loud the sound is.
		 */
		protected var _volume:Number;
		/**
		 * Internal tracker for total volume adjustment.
		 */
		protected var _volumeAdjust:Number;
		/**
		 * Internal tracker for whether the sound is looping or not.
		 */
		protected var _looped:Boolean;
		/**
		 * Internal tracker for whether the sound is playing or not.
		 */
		protected var _playing:Boolean;
		/**
		 * Internal tracker for the sound's "target" (for proximity and panning).
		 */
		protected var _target:FlxObject;
		/**
		 * Internal tracker for the maximum effective radius of this sound (for proximity and panning).
		 */
		protected var _radius:Number;
		/**
		 * Internal tracker for whether to pan the sound left and right.  Default is false.
		 */
		protected var _pan:Boolean;
		/**
		 * Internal timer used to keep track of requests to fade out the sound playback.
		 */
		protected var _fadeOutTimer:Number;
		/**
		 * Internal helper for fading out sounds.
		 */
		protected var _fadeOutTotal:Number;
		/**
		 * Internal flag for whether to pause or stop the sound when it's done fading out.
		 */
		protected var _pauseOnFadeOut:Boolean;
		/**
		 * Internal timer for fading in the sound playback.
		 */
		protected var _fadeInTimer:Number;
		/**
		 * Internal helper for fading in sounds.
		 */
		protected var _fadeInTotal:Number;
		
		/**
		 * The FlxSound constructor gets all the variables initialized, but NOT ready to play a sound yet.
		 */
		public function FlxSound()
		{
			super();
			createSound();
		}
		
		/**
		 * An internal function for clearing all the variables used by sounds.
		 */
		protected function createSound():void
		{
			destroy();
			x = 0;
			y = 0;
			if(_transform == null)
				_transform = new SoundTransform();
			_transform.pan = 0;
			_sound = null;
			_position = 0;
			_volume = 1.0;
			_volumeAdjust = 1.0;
			_looped = false;
			_target = null;
			_radius = 0;
			_pan = false;
			_playing = false;
			_fadeOutTimer = 0;
			_fadeOutTotal = 0;
			_pauseOnFadeOut = false;
			_fadeInTimer = 0;
			_fadeInTotal = 0;
			exists = false;
			active = false;
			visible = false;
			name = null;
			artist = null;
			amplitude = 0;
			amplitudeLeft = 0;
			amplitudeRight = 0;
			autoDestroy = false;
		}
		
		/**
		 * Clean up memory.
		 */
		override public function destroy():void
		{
			kill();

			_transform = null;
			_sound = null;
			_channel = null;
			_target = null;
			name = null;
			artist = null;
			
			super.destroy();
		}
		
		/**
		 * Handles fade out, fade in, panning, proximity, and amplitude operations each frame.
		 */
		override public function update():void
		{
			if(_position != 0)
				return;
			
			var radial:Number = 1.0;
			var fade:Number = 1.0;
			
			//Distance-based volume control
			if(_target != null)
			{
				radial = FlxU.getDistance(new FlxPoint(_target.x,_target.y),new FlxPoint(x,y))/_radius;
				if(radial < 0) radial = 0;
				if(radial > 1) radial = 1;
				
				if(_pan)
				{
					var d:Number = (_target.x-x)/_radius;
					if(d < -1) d = -1;
					else if(d > 1) d = 1;
					_transform.pan = d;
				}
			}
			
			//Cross-fading volume control
			if(_fadeOutTimer > 0)
			{
				_fadeOutTimer -= FlxG.elapsed;
				if(_fadeOutTimer <= 0)
				{
					if(_pauseOnFadeOut)
						pause();
					else
						stop();
				}
				fade = _fadeOutTimer/_fadeOutTotal;
				if(fade < 0) fade = 0;
			}
			else if(_fadeInTimer > 0)
			{
				_fadeInTimer -= FlxG.elapsed;
				fade = _fadeInTimer/_fadeInTotal;
				if(fade < 0) fade = 0;
				fade = 1 - fade;
			}
			
			_volumeAdjust = radial*fade;
			updateTransform();
			
			if((_transform.volume > 0) && (_channel != null))
			{
				amplitudeLeft = _channel.leftPeak/_transform.volume;
				amplitudeRight = _channel.rightPeak/_transform.volume;
				amplitude = (amplitudeLeft+amplitudeRight)*0.5;
			}
		}
		
		override public function kill():void
		{
			super.kill();
			if(_channel != null)
				stop();
		}
		
		public function isPlaying():Boolean {
			return _playing;
		}
		
		/**
		 * One of two main setup functions for sounds, this function loads a sound from an embedded MP3.
		 * 
		 * @param	EmbeddedSound	An embedded Class object representing an MP3 file.
		 * @param	Looped			Whether or not this sound should loop endlessly.
		 * @param	AutoDestroy		Whether or not this <code>FlxSound</code> instance should be destroyed when the sound finishes playing.  Default value is false, but FlxG.play() and FlxG.stream() will set it to true by default.
		 * 
		 * @return	This <code>FlxSound</code> instance (nice for chaining stuff together, if you're into that).
		 */
		public function loadEmbedded(EmbeddedSound:Class, Looped:Boolean=false, AutoDestroy:Boolean=false):FlxSound
		{
			stop();
			createSound();
			_sound = new EmbeddedSound();
			//NOTE: can't pull ID3 info from embedded sound currently
			_looped = Looped;
			updateTransform();
			exists = true;
			return this;
		}
		
		/**
		 * One of two main setup functions for sounds, this function loads a sound from a URL.
		 * 
		 * @param	EmbeddedSound	A string representing the URL of the MP3 file you want to play.
		 * @param	Looped			Whether or not this sound should loop endlessly.
		 * @param	AutoDestroy		Whether or not this <code>FlxSound</code> instance should be destroyed when the sound finishes playing.  Default value is false, but FlxG.play() and FlxG.stream() will set it to true by default.
		 * 
		 * @return	This <code>FlxSound</code> instance (nice for chaining stuff together, if you're into that).
		 */
		public function loadStream(SoundURL:String, Looped:Boolean=false, AutoDestroy:Boolean=false):FlxSound
		{
			stop();
			createSound();
			_sound = new Sound();
			_sound.addEventListener(Event.ID3, gotID3);
			_sound.load(new URLRequest(SoundURL));
			_looped = Looped;
			updateTransform();
			exists = true;
			return this;
		}
		
		/**
		 * Call this function if you want this sound's volume to change
		 * based on distance from a particular FlxCore object.
		 * 
		 * @param	X		The X position of the sound.
		 * @param	Y		The Y position of the sound.
		 * @param	Object	The object you want to track.
		 * @param	Radius	The maximum distance this sound can travel.
		 * @param	Pan		Whether the sound should pan in addition to the volume changes (default: true).
		 * 
		 * @return	This FlxSound instance (nice for chaining stuff together, if you're into that).
		 */
		public function proximity(X:Number,Y:Number,Object:FlxObject,Radius:Number,Pan:Boolean=true):FlxSound
		{
			x = X;
			y = Y;
			_target = Object;
			_radius = Radius;
			_pan = Pan;
			return this;
		}
		
		/**
		 * Call this function to play the sound - also works on paused sounds.
		 * 
		 * @param	ForceRestart	Whether to start the sound over or not.  Default value is false, meaning if the sound is already playing or was paused when you call <code>play()</code>, it will continue playing from its current position, NOT start again from the beginning.
		 */
		public function play(ForceRestart:Boolean=false):void
		{
			if(_position < 0)
				return;
			if(ForceRestart)
			{
				var oldAutoDestroy:Boolean = autoDestroy;
				autoDestroy = false;
				stop();
				autoDestroy = oldAutoDestroy;
			}
			if(_looped)
			{
				if(_position == 0)
				{
					if(_channel == null)
						_channel = _sound.play(0,9999,_transform);
					if(_channel == null)
						exists = false;
				}
				else
				{
					_channel = _sound.play(_position,0,_transform);
					if(_channel == null)
						exists = false;
					else
						_channel.addEventListener(Event.SOUND_COMPLETE, looped);
				}
			}
			else
			{
				if(_position == 0)
				{
					if(_channel == null)
					{
						_channel = _sound.play(0,0,_transform);
						if(_channel == null)
							exists = false;
						else
							_channel.addEventListener(Event.SOUND_COMPLETE, stopped);
					}
				}
				else
				{
					_channel = _sound.play(_position,0,_transform);
					if(_channel == null)
						exists = false;
				}
			}
			active = (_channel != null);
			_position = 0;
		}
		
		/**
		 * Unpause a sound.  Only works on sounds that have been paused.
		 */
		public function resume():void
		{
			if(_position <= 0)
				return;
			if(_looped)
			{
				_channel = _sound.play(_position,0,_transform);
				if(_channel == null)
					exists = false;
				else
					_channel.addEventListener(Event.SOUND_COMPLETE, looped);
			}
			else
			{
				_channel = _sound.play(_position,0,_transform);
				if(_channel == null)
					exists = false;
			}
			active = (_channel != null);
		}
		
		/**
		 * Call this function to pause this sound.
		 */
		public function pause():void
		{
			if(_channel == null)
			{
				_position = -1;
				return;
			}
			_position = _channel.position;
			_channel.stop();
			if(_looped)
			{
				while(_position >= _sound.length)
					_position -= _sound.length;
			}
			if(_position <= 0)
				_position = 1;
			_channel = null;
			active = false;
		}
		
		/**
		 * Call this function to stop this sound.
		 */
		public function stop():void
		{
			_position = 0;
			if(_channel != null)
			{
				_channel.stop();
				stopped();
				_playing = false;
			}
		}
		
		/**
		 * Call this function to make this sound fade out over a certain time interval.
		 * 
		 * @param	Seconds			The amount of time the fade out operation should take.
		 * @param	PauseInstead	Tells the sound to pause on fadeout, instead of stopping.
		 */
		public function fadeOut(Seconds:Number,PauseInstead:Boolean=false):void
		{
			_pauseOnFadeOut = PauseInstead;
			_fadeInTimer = 0;
			_fadeOutTimer = Seconds;
			_fadeOutTotal = _fadeOutTimer;
		}
		
		/**
		 * Call this function to make a sound fade in over a certain
		 * time interval (calls <code>play()</code> automatically).
		 * 
		 * @param	Seconds		The amount of time the fade-in operation should take.
		 */
		public function fadeIn(Seconds:Number):void
		{
			_fadeOutTimer = 0;
			_fadeInTimer = Seconds;
			_fadeInTotal = _fadeInTimer;
			play();
		}
		
		/**
		 * Set <code>volume</code> to a value between 0 and 1 to change how this sound is.
		 */
		public function get volume():Number
		{
			return _volume;
		}
		
		/**
		 * @private
		 */
		public function set volume(Volume:Number):void
		{
			_volume = Volume;
			if(_volume < 0)
				_volume = 0;
			else if(_volume > 1)
				_volume = 1;
			updateTransform();
		}
		
		/**
		 * Returns the currently selected "real" volume of the sound (takes fades and proximity into account).
		 * 
		 * @return	The adjusted volume of the sound.
		 */
		public function getActualVolume():Number
		{
			return _volume*_volumeAdjust;
		}
		
		/**
		 * Call after adjusting the volume to update the sound channel's settings.
		 */
		internal function updateTransform():void
		{
			_transform.volume = (FlxG.mute?0:1)*FlxG.volume*_volume*_volumeAdjust;
			if(_channel != null)
				_channel.soundTransform = _transform;
		}
		
		/**
		 * An internal helper function used to help Flash resume playing a looped sound.
		 * 
		 * @param	event		An <code>Event</code> object.
		 */
		protected function looped(event:Event=null):void
		{
		    if (_channel == null)
		    	return;
	        _channel.removeEventListener(Event.SOUND_COMPLETE,looped);
	        _channel = null;
			play();
		}

		/**
		 * An internal helper function used to help Flash clean up and re-use finished sounds.
		 * 
		 * @param	event		An <code>Event</code> object.
		 */
		protected function stopped(event:Event=null):void
		{
			_playing = false;
			if(!_looped)
	        	_channel.removeEventListener(Event.SOUND_COMPLETE,stopped);
	        else
	        	_channel.removeEventListener(Event.SOUND_COMPLETE,looped);
	        _channel = null;
			active = false;
			if(autoDestroy)
				destroy();
		}
		
		/**
		 * Internal event handler for ID3 info (i.e. fetching the song name).
		 * 
		 * @param	event	An <code>Event</code> object.
		 */
		protected function gotID3(event:Event=null):void
		{
			FlxG.log("got ID3 info!");
			if(_sound.id3.songName)
				if(_sound.id3.songName.length > 0)
					name = _sound.id3.songName;
			if(_sound.id3.artist)
				if(_sound.id3.artist.length > 0)
					artist = _sound.id3.artist;
			_sound.removeEventListener(Event.ID3, gotID3);
		}
	}
}

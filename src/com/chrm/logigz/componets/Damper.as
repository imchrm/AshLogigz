/**
 * Created by Dmitry Cheremisov on 18-Jan-17.
 */
package com.chrm.logigz.componets
{
	import com.chrm.logigz.GameConfig;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	import starling.animation.Transitions;

	public class Damper
	{
		private static const log:ILogger = getLogger(Damper);
		
		//acceleration
		public var a : Number = 0;
		// total time
		public var T : Number = 0;
		// initial velocity
		private var _V : Number = 0;
		// total spacing
		public var S : Number = 0;
		
		public var isAction:Boolean = false;
		public var isBegan:Boolean;
		
		public var sign : int;
		public var debug : Boolean = false;
		// recycled data
		
		public var dt : Number = 0;
		public var tc : Number = 0;
		public var v0 : Number = 0;
		public var ds : Number = 0;
		public var sc : Number = 0;
		
		private var osc : Number = 0;// значение пути предыдущей итерации, чтобы узнать текущее преращение между текущим путем
		
		private var config : GameConfig;
		
		public function Damper(acceleration : Number, config : GameConfig)
		{
			a = acceleration;
			this.config = config;
		}

		/**
		 * Initial Velocity
		 * 
		 * 
		 */
		public function get V():Number
		{
			return _V;
		}

		public function set V(value:Number):void
		{
			_V = Math.abs(value);
			sign = getSign(value);
			
			T = _V / a;
			S = _V * T - a * T * T/ 2;
//			S = _V * T;

//			var o:int = S % config.tileSize;
			
			v0 = _V;

			dt = 0;
			tc = 0;
			ds = 0;
			sc = 0;
			osc = 0;
			
			isAction = true;
			isBegan = true;
		}
		public function setOffset(val : Number):void
		{
			var ts : Number = config.tileSize;
			var ts_2 : int = ts >> 1;
			var o:Number;
			var y:Number = val - ts_2;
			var i : int = Math.floor( y / ts );
			var l : int = i * ts;
			var r : int = ++i * ts;
			var rs : Number = r - y;
			var ls : Number = y - l;
			o = ( rs < ls) ? rs : l - y;
			var n : Number = Math.floor( S / ts );
			S = n * ts;
			if(n == 0 && o < 0)
				sign = -1;
			S += sign * o;
			
//			log.debug("Y:{0}, S:{1}, o:{2}, T:{3}",[y, S, o, T]);
		}
		public function getSign( val : Number) : int
		{
			return (val >= 0 )? 1 : -1;
		}
		public function getSpace(val : Number) : Number
		{
			if(isBegan)
			{
				isBegan = false;
			}
			else
			{
				tc += val;
				if (tc < T)
				{
//					var ns:Number = Transitions.getTransition(Transitions.EASE_OUT_BACK)(tc / T);
					var ns:Number = easeOutCubic(tc / T);
					sc = S * ns;
					ds = sc - osc;
					if(ds < 0.1)
					{
						ds = S - osc;
						stop();
					}
					else if(ns == 1)
					{
						stop();
					}
					else
					{
						osc = sc;
					}
				}
				else
				{
					ds = S - osc;
					stop();
				}
				
			}
//			log.debug("ds:{0}", [ds]);
			return sign * ds;
		}
		public function stop():void
		{
			isAction = false;
		}
		private function easeOutCubic( t : Number ) : Number
		{
			return (--t)*t*t+1;
		}

	}
}

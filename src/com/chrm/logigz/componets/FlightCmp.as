/**
 * Created by Dmitry Cheremisov on 11-May-17.
 */
package com.chrm.logigz.componets
{
	public class FlightCmp
	{
		private static var st:uint = 0;
		
		public static const ST_INIT_IN				: uint = st++;
		public static const ST_INIT_OUT				: uint = st++;
		public static const ST_FLIGHT_IN				: uint = st++;
		public static const ST_FLIGHT_OUT				: uint = st++;
		public static const ST_IN_ORDER				: uint = st++;
		public static const ST_END					: uint = st++;
		
		public var state:uint = ST_INIT_IN;
		
		//acceleration
		public var A : Number = 0;// ?
		// total time
		public var T : Number = 0;
		// initial velocity
		public var V : Number = 0;// ?
		// total spacing
		public var SX : Number = 0;
		public var SY : Number = 0;
		
		public var signX : int;
		public var signY : int;
		
		// recycled data

		public var tc : Number = 0;// значение текущего времени от начала перемещения
		public var oscX : Number = 0;// значение пути предыдущей итерации, чтобы узнать текущее преращение между текущим путем
		public var oscY : Number = 0;// значение пути предыдущей итерации, чтобы узнать текущее преращение между текущим путем
		
		public var sX : Number;// space X
		public var sY : Number;// space Y
		
		public function FlightCmp()
		{
		}
	}
}

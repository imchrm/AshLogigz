/**
 * Created by Dmitry Cheremisov on 19-Feb-17.
 */
package com.chrm.logigz.vo
{
	public class FlyVO
	{
		//acceleration
		public var A : Number = 0;
		// total time
		public var T : Number = 0;
		// initial velocity
		public var V : Number = 0;
		// total spacing
		public var S : Number = 0;
		// offset of tile position in untouch of moment time
		public var offset : Number = 0;

		public var sign : int;

		// recycled data

//		public var dt : Number = 0;
		public var tc : Number = 0;// значение текущего времени от начала перемещения
//		public var sc : Number = 0;// значение текущей позиции от начала перемещения 
		public var osc : Number = 0;// значение пути предыдущей итерации, чтобы узнать текущее преращение между текущим путем
//		public var ds : Number = 0;// текущее прирощение позиции за время цикла update(time)

//		private var tileSize : int;

		public function FlyVO(acceleration : Number=0)
		{
			this.A = acceleration;
//			this.tileSize = tileSize;
		}
	}
}

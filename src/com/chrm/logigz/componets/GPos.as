/**
 * Created by Dmitry Cheremisov on 07-Dec-16.
 */
package com.chrm.logigz.componets
{
	import flash.geom.Point;
	
	import org.as3commons.logging.simple.USE_LINE_NUMBERS;
	
	public class GPos extends Pos
	{
		// parking pos
		public var px:Number;
		// parking pos
		public var py:Number;

		public function GPos(x : Number = 0, y : Number = 0, px : Number = 0, py : Number = 0 )
		{
			super(x, y);
			
			this.px = px;
			this.py = py;
			
		}
	}
}

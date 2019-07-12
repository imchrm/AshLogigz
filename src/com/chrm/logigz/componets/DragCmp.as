/**
 * Created by Dmitry Cheremisov on 02-Jan-17.
 */
package com.chrm.logigz.componets
{
	import flash.geom.Point;

	public class DragCmp
	{
		public var controlX : Number;
		public var controlY : Number;
		public var offset : Point;
		
		public function DragCmp(offsetX : Number, offsetY : Number )
		{
			this.offset = new Point(offsetX, offsetY);
		}
	}
}

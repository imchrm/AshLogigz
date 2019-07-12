/**
 * Created by Dmitry Cheremisov on 19-Feb-17.
 */
package com.chrm.logigz.componets
{
	public class AxisCmp
	{
//		0 is horizontal; 1 is vertical
		public var axis : int = -1;
//		number of cow or row, if axis horizontal 
		public var num : int = -1;
		
		public function AxisCmp( axis : int, num : int)
		{
			this.axis = axis;
			this.num = num;
		}
	}
}

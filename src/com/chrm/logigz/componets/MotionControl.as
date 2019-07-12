/**
 * Created by Dmitry Cheremisov on 08-Dec-16.
 */
package com.chrm.logigz.componets
{

	public class MotionControl
	{
		public var angle:Number;
		public var dir:int;

		public function MotionControl(angle:Number, dir:int)
		{
			this.angle = angle;
			this.dir = dir;
		}
	}
}

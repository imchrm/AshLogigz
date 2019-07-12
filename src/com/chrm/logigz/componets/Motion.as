/**
 * Created by Dmitry Cheremisov on 08-Dec-16.
 */
package com.chrm.logigz.componets
{
	import flash.geom.Point;

	public class Motion
	{
		public var velocity:Point;
		public var angularVelocity:Number;

		public function Motion(velocityX:Number, velocityY:Number, angularVelocity:Number)
		{
			velocity = new Point(velocityX, velocityY);
			this.angularVelocity = angularVelocity;
		}
	}
}

/**
 * Created by Dmitry Cheremisov on 02-Jan-17.
 */
package com.chrm.logigz.componets
{
	public class SlideMotion
	{
		public var velocityX : Number;
		public var velocityY : Number;
		
		public var damping : Number;
		public var velocityX0 : Number;
		public var velocityY0 : Number;
		
		/**
		 * SlideMotion 
		 * 
		 * 
		 * @param velocityX
		 * @param velocityY
		 * @param dumping
		 */
		public function SlideMotion( velocityX : Number = 0, velocityY : Number = 0, dumping : Number = 0)
		{
			this.velocityX = velocityX;
			this.velocityY = velocityY;
			this.damping = damping;
		}
	}
}

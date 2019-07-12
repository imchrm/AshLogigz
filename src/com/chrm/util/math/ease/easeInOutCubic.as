/**
 * Created by Dmitry Cheremisov on 22-May-17.
 */
package com.chrm.util.math.ease
{
	public function easeInOutCubic(t : Number) : Number
	{
		return (t < .5) ? 4 * t * t * t : ( t - 1 ) * ( 2 * t - 2 ) * ( 2 * t - 2 ) + 1;
	}
}

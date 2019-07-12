/**
 * Created by Dmitry Cheremisov on 19-May-17.
 */
package com.chrm.util.math.ease
{
	[Inline]
	public function easeOutCubic( t : Number ) : Number
	{
		return (--t)*t*t+1;
	}
}

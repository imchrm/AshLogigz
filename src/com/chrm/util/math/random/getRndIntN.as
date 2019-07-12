/**
 * Created by Dmitry Cheremisov on 11-May-17.
 */
package com.chrm.util.math.random
{
	/**
	 *  return random integer from 1:N diapason
	 *
	 */
	public function getRndIntN(N : int ) : int
	{
		return Math.round( Math.random() * (N - 1) + 1 ) as int;
	}
}

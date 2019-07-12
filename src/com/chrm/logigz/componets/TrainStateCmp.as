/**
 * Created by Dmitry Cheremisov on 10-Mar-17.
 */
package com.chrm.logigz.componets
{
	import com.chrm.logigz.vo.StateVO;
	
	public class TrainStateCmp
	{
		public var stateVA : StateVO;
		
		public function TrainStateCmp( state : StateVO = null)
		{
			if(!state)
				stateVA = new StateVO();
		}
	}
}

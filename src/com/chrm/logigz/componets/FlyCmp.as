/**
 * Created by Dmitry Cheremisov on 30-Jan-17.
 */
package com.chrm.logigz.componets
{
	import com.chrm.logigz.vo.FlyVO;
	import com.chrm.logigz.vo.SpaceVO;

	public class FlyCmp
	{
//		private static var stc : int = 0;
		
//		public var state : int = 0;
		public var flyVO:FlyVO;
		public var spaceVO:SpaceVO;
		
		public function FlyCmp(space : SpaceVO, flyVO : FlyVO = null)
		{
			this.spaceVO = space;
			this.flyVO = flyVO;
		}
	}
}

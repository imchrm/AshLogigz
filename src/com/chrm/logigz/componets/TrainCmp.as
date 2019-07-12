/**
 * Created by Dmitry Cheremisov on 26-Feb-17. 
 */
package com.chrm.logigz.componets
{
	import com.chrm.logigz.vo.StateVO;
	
	import net.richardlord.ash.core.Entity;
	
	public class TrainCmp
	{
		private static var stc : int = 0;
		
		public static const ST_CREATED 			: int = stc++;
//		public static const ST_END 			: int = stc++;
		public static const ST_HOOK 				: int = stc++;
		public static const ST_FLY 				: int = stc++;
		public static const ST_INIT_FLY 			: int = stc++;
		public static const ST_CLEAN 				: int = stc++;
		
		public var stateVA : StateVO;
		public var vagons : Vector.<Entity> = new <Entity>[];
	}
}

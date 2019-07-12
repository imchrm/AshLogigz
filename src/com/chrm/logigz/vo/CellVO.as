/**
 * Created by Dmitry Cheremisov on 04-Apr-17.
 */
package com.chrm.logigz.vo
{
	import net.richardlord.ash.core.Entity;
	
	public class CellVO
	{
		public var e:Entity;
		public var me:Entity;
		
		public function CellVO(e:Entity, me:Entity = null)
		{
			this.e = e;
			this.me = me;
		}
	}
}

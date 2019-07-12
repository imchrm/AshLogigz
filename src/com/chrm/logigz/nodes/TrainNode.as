/**
 * Created by Dmitry Cheremisov on 30-Jan-17.
 */
package com.chrm.logigz.nodes
{
	import com.chrm.logigz.componets.AxisCmp;
	import com.chrm.logigz.componets.FlyCmp;
	import com.chrm.logigz.componets.TrainCmp;
	
	import net.richardlord.ash.core.Node;

	public class TrainNode extends Node
	{
		public var axis : AxisCmp;
		public var fly : FlyCmp;
		public var train : TrainCmp;
	}
}

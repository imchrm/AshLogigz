/**
 * Created by Dmitry Cheremisov on 08-Dec-16.
 */
package com.chrm.logigz.nodes
{
	import com.chrm.logigz.componets.MotionControl;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.Motion;

	import net.richardlord.ash.core.Node;

	public class MotionControlNode extends Node
	{
		public var position:Pos;
		public var motion:Motion;
		public var control:MotionControl;
	}
}

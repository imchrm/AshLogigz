/**
 * Created by Dmitry Cheremisov on 18-Dec-16.
 */
package com.chrm.logigz.nodes
{
	import com.chrm.logigz.componets.Motion;
	import com.chrm.logigz.componets.Pos;

	import net.richardlord.ash.core.Node;

	public class MovementNode extends Node
	{
		public var position : Pos;
		public var motion : Motion;

		public function MovementNode()
		{
			super();
		}
	}
}

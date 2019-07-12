/**
 * Created by Dmitry Cheremisov on 18-Dec-16.
 */
package com.chrm.logigz.nodes
{
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.SlideMotion;
	import com.chrm.logigz.componets.SpaceCmp;
	import com.chrm.logigz.componets.Tile;

	import net.richardlord.ash.core.Node;

	public class SlideMovementNode extends Node
	{
		public var tile : Tile;
		public var position : Pos;
		public var space : SpaceCmp;
//		public var movement : SlideMotion;

		public function SlideMovementNode()
		{
			super();
		}
	}
}

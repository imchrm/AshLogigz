/**
 * Created by Dmitry Cheremisov on 02-Jan-17.
 */
package com.chrm.logigz.nodes
{
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.SlideMotion;
	import com.chrm.logigz.componets.DragCmp;
	import com.chrm.logigz.componets.SpaceCmp;
	import com.chrm.logigz.componets.Tile;
	import com.chrm.logigz.componets.TrainStateCmp;
	
	import net.richardlord.ash.core.Node;

	public class VagonNode extends Node
	{
		public var tile : Tile;
		public var trainState : TrainStateCmp;
		public var space : SpaceCmp;
		public var position : Pos;
		public var motion : SlideMotion;
		public var drag : DragCmp;
	}
}

/**
 * Created by Dmitry Cheremisov on 09-Dec-16.
 */
package com.chrm.logigz.nodes
{
	import com.chrm.logigz.componets.Dspl;
	import com.chrm.logigz.componets.GDspl;
	import com.chrm.logigz.componets.GPos;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.Tile;
	
	import net.richardlord.ash.core.Node;

	public class RenderNode extends Node
	{
		public var tile:Tile;
		public var pos:Pos;
		public var dspl:Dspl;
		public var gpos:GPos;
		public var gdspl:GDspl;
	}
}

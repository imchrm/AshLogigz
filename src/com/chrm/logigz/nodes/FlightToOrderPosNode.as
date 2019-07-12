/**
 * Created by Dmitry Cheremisov on 12-May-17.
 */
package com.chrm.logigz.nodes
{
	import com.chrm.logigz.componets.FlightCmp;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.DPos;
	import com.chrm.logigz.componets.Tile;
	
	import net.richardlord.ash.core.Node;
	
	public class FlightToOrderPosNode extends Node
	{
		public var tile:Tile;
		public var flight:FlightCmp;
		public var pos:Pos;
		public var dpos:DPos;
		
		public function FlightToOrderPosNode()
		{
			super();
		}
	}
}

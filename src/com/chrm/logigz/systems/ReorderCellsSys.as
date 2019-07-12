/**
 * Created by Dmitry Cheremisov on 04-Apr-17. 
 */
package com.chrm.logigz.systems
{
	import com.chrm.logigz.LGame;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.componets.TrainCmp;
	import com.chrm.logigz.nodes.TrainNode;
	import com.chrm.logigz.nodes.VagonNode;
	import com.chrm.logigz.vo.CellVO;
	
	import flash.geom.Point;
	
	import net.richardlord.ash.core.Entity;
	
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class ReorderCellsSys extends System
	{
		private static const log:ILogger = getLogger(ReorderCellsSys);
		
		private var game:LGame;
		
		public var vagonNds : NodeList;
		public var trainNds : NodeList;
		
		public function ReorderCellsSys()
		{
		}
		override public function addToGame( game : Game ) : void
		{
			this.game = game as LGame;
			
			vagonNds = game.getNodeList( VagonNode );
			trainNds = game.getNodeList( TrainNode );
		}
		override public function update(time : Number ):void
		{
			var trainNd : TrainNode;
			for(trainNd = trainNds.head; trainNd; trainNd = trainNd.next)
			{
				if(trainNd.train.stateVA.value == TrainCmp.ST_CLEAN)
				{
					var vgns :Vector.<Entity> = trainNd.train.vagons;
//					var m:String = (trainNd.axis.axis == 1)? "--- sortByPosX" : "--- sortByPosY";
//					log.debug(m);
					var cells:Vector.<CellVO>;
					if(trainNd.axis.axis == 1)
					{
						vgns.sort(sortByPosX);
						cells = game.config.rows[trainNd.axis.num];
					}
					else
					{
						vgns.sort(sortByPosY);
						cells = game.config.columns[trainNd.axis.num];
					}
					reorder(cells, vgns);
				}
			}
		}
		
		private function reorder(vCells:Vector.<CellVO>, vgns:Vector.<Entity>):void
		{
			var c:int = vCells.length;
			for(var i:int = 0; i < c; i++)
			{
//				log.debug("    change: {0} : {1}", [vCells[i].e.name, vgns[i].name]);
				vCells[i].e = vgns[i];
			}
		}
		
		private function sortByPosX(a:Entity, b:Entity):int
		{
			var ap:Pos = (a.get(Pos) as Pos);
			var bp:Pos = (b.get(Pos) as Pos);
			if(ap.x < bp.x)
				return -1;
			if(ap.x == bp.x)
				return 0;
			else
				return 1;
		}
		private function sortByPosY(a:Entity, b:Entity):int
		{
			var ap:Pos = a.get(Pos);
			var bp:Pos = b.get(Pos);
			if(ap.y < bp.y)
				return -1;
			if(ap.y == bp.y)
				return 0;
			else
				return 1;
		}
	}
}

/**
 * Created by Dmitry Cheremisov on 06-Mar-17.
 */
package com.chrm.logigz.systems
{
	import com.chrm.logigz.componets.FlyCmp;
	import com.chrm.logigz.componets.TrainCmp;
	import com.chrm.logigz.nodes.TrainNode;
	import com.chrm.logigz.nodes.VagonNode;
	
	import net.richardlord.ash.core.Entity;
	
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class CleanTrainSystem extends System
	{
		private static const log:ILogger = getLogger(CleanTrainSystem);
		
		private var game:Game;
		
		public var vagonNds : NodeList;
		public var trainNds : NodeList;
		
		public function CleanTrainSystem()
		{
		}
		
		override public function addToGame( game : Game ) : void
		{
			this.game = game;
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
					var vgns:Vector.<Entity> = trainNd.train.vagons;
					while (vgns.length > 0)
					{
						var se:Entity = vgns.shift();
						game.removeEntity(se);
					}
					game.removeEntity(trainNd.entity);
//					log.debug("Remove Train");
				}
			}
		}
	}
}

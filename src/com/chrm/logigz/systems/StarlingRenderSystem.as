/**
 * Created by Dmitry Cheremisov on 09-Dec-16.
 */
package com.chrm.logigz.systems
{
	import com.chrm.logigz.LGame;
	import com.chrm.logigz.componets.Dspl;
	import com.chrm.logigz.componets.GPos;
	import com.chrm.logigz.componets.Pos;
	import com.chrm.logigz.nodes.RenderNode;

	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;

	public class StarlingRenderSystem extends System
	{
		private static const log:ILogger = getLogger(StarlingRenderSystem);
		public var container : DisplayObjectContainer;
		
		private var game : LGame;
		
		private var nodes:NodeList;

		public function StarlingRenderSystem( )
		{
		}
		override public function addToGame( game : Game ):void
		{
			this.game = game as LGame;
			this.container = this.game.borderContainer;
			nodes = game.getNodeList( RenderNode );
			/*var node:RenderNode;
			for( node = nodes.head; node; node = node.next )
			{
				addToDisplay( node );
			}
			nodes.nodeAdded.add( addToDisplay );*/
//			nodes.nodeRemoved.add( removeFromDisplay );
			
		}
		private function removeFromDisplay( node : RenderNode ):void
		{
//			this.rootContainer.removeChild( node.dspl.displayObject );
		}

		private function addToDisplay( node : RenderNode ):void
		{
			this.container.addChild( node.dspl.displayObject );
			log.debug("add: tile_{0}", [node.tile.num.toString()]);
		}
		
		override public function update( time : Number ) : void
		{
//			log.debug
//			return;
			var node : RenderNode;
			var dsp : DisplayObject;
			var pos : Pos;
			var gdsp : DisplayObject;
			var gpos : GPos;
			for( node = nodes.head; node != null; node = node.next )
			{
				var dspc:Dspl = node.dspl;
				dsp = dspc.displayObject;
				pos = node.pos;
				
				if(dsp.x != pos.x)
					dsp.x = pos.x;
				if(dsp.y != pos.y)
					dsp.y = pos.y;
				
				gpos = node.gpos;
				gdsp = node.gdspl.displayObject;
				if(gpos.x != gpos.px)
				{
					if(!gdsp.visible)
						gdsp.visible = true;
					if(gdsp.x != gpos.x)
						gdsp.x = gpos.x;
				}
				else
				{
					if(gdsp.visible)
						gdsp.visible = false;
					if(gdsp.x != gpos.px)
						gdsp.x = gpos.px;
				}
				if(gpos.y != gpos.py)
				{
					if(!gdsp.visible)
						gdsp.visible = true;
					if(gdsp.y != gpos.y)
						gdsp.y = gpos.y;
				}
				else
				{
					if(gdsp.visible)
						gdsp.visible = false;
					if(gdsp.y != gpos.py)
						gdsp.y = gpos.py;
				}
			}
		}
	}
}

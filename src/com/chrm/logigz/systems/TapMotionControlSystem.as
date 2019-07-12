/**
 * Created by Dmitry Cheremisov on 08-Dec-16.
 */
package com.chrm.logigz.systems
{
	import com.chrm.starling.input.TapCatcher;
	import com.chrm.logigz.def.ShipConstants;
	import com.chrm.logigz.nodes.MotionControlNode;

	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.core.NodeList;
	import net.richardlord.ash.core.System;
	import net.richardlord.ash.tools.ListIteratingSystem;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	import starling.utils.MathUtil;

	import starling.utils.rad2deg;

	public class TapMotionControlSystem extends System
	{
		private static const log:ILogger = getLogger(TapMotionControlSystem);

		private static const D_PI:Number = 6.283;// double Pi: 2*Pi = 6.283185307179586476925286766559

		private var touchCatcher:TapCatcher;
		private var nodes : NodeList;
		private var game : Game;
		public function TapMotionControlSystem(tapCatcher : TapCatcher )
		{
			super();
//			super( MotionControlNode, updateNode );
			this.touchCatcher = tapCatcher;
		}
		override public function addToGame( game : Game ) : void
		{
			this.game = game;
			nodes = game.getNodeList( MotionControlNode );
//			movement.nodeAdded.add( addTo
		}
		override public function update(time : Number ):void
		{
//			nodes = game.getNodeList( MotionControlNode );
			var node:MotionControlNode;
			for(node = nodes.head; node; node = node.next)
			{
				var px :Number = node.position.point.x;
				var py :Number = node.position.point.y;
				var pr :Number = node.position.rotation;
				var aa :Number = node.control.angle;
				var ad :int = node.control.dir;
				var va :Number = node.motion.angularVelocity;
				
				if(touchCatcher.isControlPointChanged)
				{
					touchCatcher.isControlPointChanged = false;
					
					var x :Number = touchCatcher.controlPoint.x - px;
					var y :Number = touchCatcher.controlPoint.y - py;
					aa = Math.atan2(y, x);

					log.debug("start x/y:{0}/{1} rad:{2}, deg:{3}",[x, y, aa, rad2deg(aa)]);

					pr = MathUtil.normalizeAngle(pr);
					node.position.rotation = pr;
					if(pr != aa)
					{
//						определение направления вращения: 1 по часовой, -1 против
						var a0 : Number;
						var a1 : Number;
						if(aa > pr)
						{
							a0 = aa - pr;
							a1 = D_PI - aa + pr;
							ad = (a0 < a1) ? 1 : -1;// 1 по часовой; -1 против
						}
						else
						{
							a0 = pr - aa;
							a1 = D_PI - pr + aa;
							ad = (a0 < a1) ? -1 : 1;
						}

//						приведение целевого угла к следующему значению после угла поворота
// 						без перескока с минуса на плюс и наоборот

//						пересечение угла 180 (Pi radian) по часовой
						if(ad > 0 && pr > 0 && aa < 0 )
							aa = D_PI + aa;
//						пересечение угла 180 (Pi radian) против часовой
						else if(ad < 0 && pr < 0 && aa > 0)
							aa = aa - D_PI;
					}
					node.control.angle = aa;
					node.control.dir = ad;
				}

				if(pr != aa)
				{
//					вычисление текущей скорости поворота
					var da:Number = ShipConstants.ANGULAR_VELOCITY_MAX * time;
					var na:Number = pr + ad * da;

					if ((ad * (aa - na)) > 0)
					{
						va = ad * ShipConstants.ANGULAR_VELOCITY_MAX;
					}
					else
					{
						pr = aa;
						va = 0;
					}
					node.motion.angularVelocity = va;
				}
				/*
				* Moved to FlySys
				*

				var vx:Number = node.movement.velocity.x;
				var vy:Number = node.movement.velocity.y;
				if (vx != 0)
					node.pos.point.x += vx * time;
				if (vy != 0)
					node.pos.point.y += vy * time;

				if (va != 0)
				{
					node.movement.angularVelocity = va;
					node.pos.rotation += va * time;
				}
				*/
			}
		}
	}
}

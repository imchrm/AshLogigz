/**
 * Created by Dmitry Cheremisov on 13-Apr-17.
 */
package com.chrm.logigz.vo
{
	public class PlaySt
	{
		public static var st 							: uint = 0;
		public static const ST_IDLE					: uint = st++;
		public static const ST_TOUCH 					: uint = st++;
		public static const ST_TWITCH 				: uint = st++;
		public static const ST_DRAG 					: uint = st++;
		public static const ST_RELEASE 				: uint = st++;
		public static const ST_UNTOUCH 				: uint = st++;
	}
}

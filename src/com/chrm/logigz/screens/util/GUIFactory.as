/**
 * Created by Dmitry Cheremisov on 11-May-17.
 */
package com.chrm.logigz.screens.util
{
	import com.chrm.starling.display.util.StarlingDisplayObjectConverter;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import starling.display.Button;
	
	import starling.textures.Texture;
	
	public class GUIFactory
	{
		public static const CTRL_INDENT : int = 20;
		
		public static function createSimpleBut(width:uint=160, height:uint=50, label:String = ""):Button
		{
			var tu:Texture = createButTexture(true);
//			var td:Texture = createButTexture(false);
			var b:Button = new Button(tu, label);
			
			return b;
		}
		private static function createButTexture(isUp:Boolean=true, width:uint=160, height:uint=50):Texture
		{
			var fsprt:Sprite = drawFlashButSprite(isUp, width, height);
			var txtr:Texture = StarlingDisplayObjectConverter.convertFlashDisplayObjectToTexture( fsprt );
			return txtr;
		}
		private static function drawFlashButSprite(isUp:Boolean=true, width:uint=160, height:uint=50):Sprite
		{
			var dt:uint = 2;
			var ddt:uint = dt << 1;
			
			var fsprt:Sprite = new Sprite();
			var g:Graphics = fsprt.graphics;
			g.beginFill(0x000000);
			g.drawRect(0,0, width, height);
			g.endFill();
			g.beginFill(isUp ? 0xffab33 : 0x8d4300);
			g.drawRect(dt,dt, width - ddt, height - ddt);
			g.endFill();
			
			return fsprt;
		}
	}
}

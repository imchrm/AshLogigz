package com.chrm.starling.stuff.app.preloader
{
import flash.display.GradientType;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;

public class ProgressBar extends Sprite
{
	private var _background:Shape;
	private var _bar:Shape;
	
	public function ProgressBar(width:int, height:int)
	{
		init(width, height);
	}
	
	private function init(width:int, height:int):void
	{
		var padding:Number = height * 0.2;
		var cornerRadius:Number = padding << 1;
		
		// create black rounded box for background
		
		_background = new Shape();
		_background.graphics.beginFill(0x0, 0.5);
		_background.graphics.drawRoundRect(0, 0, width, height, cornerRadius, cornerRadius);
		_background.graphics.endFill();
		addChild(_background);
		
		// create progress bar shape
		
		var barWidth:Number  = width  - (padding << 1);
		var barHeight:Number = height - (padding << 1);
		var barMatrix:Matrix = new Matrix();
		barMatrix.createGradientBox(barWidth, barHeight, Math.PI >> 1);
		
		_bar = new Shape();
		_bar.graphics.beginGradientFill(GradientType.LINEAR,
				[0xeeeeee, 0xaaaaaa], [1, 1], [0, 255], barMatrix);
		_bar.graphics.drawRect(0, 0, barWidth, barHeight);
		_bar.x = padding;
		_bar.y = padding;
		_bar.scaleX = 0.0;
		addChild(_bar);
	}
	
	public function get ratio():Number { return _bar.scaleX; }
	public function set ratio(value:Number):void
	{
		_bar.scaleX = Math.max(0.0, Math.min(1.0, value));
	}
}
}
package
{
	import flash.display.Sprite;
	
	public class TrapSprite extends Sprite
	{
		public var tileWidth:Number;
		public var tileHeight:Number;
		
		private var _trapRight:Number = 0;
		private var _trapLeft:Number = 0;
		private var _trapTop:Number = 0;
		private var _trapBottom:Number = 0;
		
		public function get trapRight():Number { return _trapRight; }
		public function set trapRight(value:Number):void {
			var old:Number = _trapRight;
			_trapRight = Math.min(tileWidth, value);
			if(old != _trapRight) Refresh();
		}
		public function get trapLeft():Number { return _trapLeft; }
		public function set trapLeft(value:Number):void {
			var old:Number = _trapLeft;
			_trapLeft = Math.min(tileWidth, value);
			if(old != _trapLeft) Refresh();
		}
		public function get trapTop():Number { return _trapTop; }
		public function set trapTop(value:Number):void {
			var old:Number = _trapTop;
			_trapTop = Math.min(tileHeight, value);
			if(old != _trapTop) Refresh();
		}
		public function get trapBottom():Number { return _trapBottom; }
		public function set trapBottom(value:Number):void {
			var old:Number = _trapBottom;
			_trapBottom = Math.min(tileHeight, value);
			if(old != _trapBottom) Refresh();
		}
		
		public function TrapSprite(tile_width:Number, tile_height:Number)
		{
			super();
			tileWidth = tile_width;
			tileHeight = tile_height;
			
			Refresh();	
		}
		
		public function Refresh():void
		{
			graphics.clear();
			graphics.lineStyle(1, 0x000000);
			graphics.beginFill(0x111133);
			graphics.drawRect(-tileWidth/2, -tileHeight/2, tileWidth, tileHeight);
			
			var trap_width:Number = tileWidth - trapLeft - trapRight;
			var trap_height:Number = tileHeight - trapTop - trapBottom;
			
			var trap_x:Number = -tileWidth/2 + trapLeft;
			var trap_y:Number = -tileHeight/2 + trapTop;
			
			graphics.beginFill(0x333399);
			graphics.lineStyle(0);
			graphics.drawRect(trap_x, trap_y, trap_width, trap_height);
			
		}
	}
}
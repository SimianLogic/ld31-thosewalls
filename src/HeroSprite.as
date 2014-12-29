package
{
	import flash.display.Sprite;
	
	public class HeroSprite extends Sprite
	{
		public var size:Number;
		public var armLength:Number = 0;
		public var isHorizontal:Boolean = true;
		
		public function HeroSprite(size:Number)
		{
			super();
			
			this.size = size;
			Refresh();
		}
		
		public function Clear():void
		{
			armLength = 0;
			Refresh();
		}
		
		public function Grow():Number
		{
			armLength += 30;
			Refresh();
			return armLength;
		}
		
		public function Refresh():void
		{
			graphics.clear();
			graphics.lineStyle(2, 0);
			
			graphics.beginFill(0x00ff00);
			graphics.drawCircle(0, 0, size/2 - 2);
			
			
			graphics.beginFill(0);
			graphics.drawRect(-size/2 + 2 - armLength, -2, 4 + armLength, 4);
			graphics.drawRect(size/2 - 6, -2, 4 + armLength, 4);
			
		}
	}
}
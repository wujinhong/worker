package swfs
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	public class BgWorker extends Sprite
	{
		private var i:int;
		private var receivedProperty:String;
		private var sendChannel:MessageChannel;
		public function BgWorker()
		{
			super();
			addEventListener( Event.ENTER_FRAME, onFrame );
			receivedProperty = Worker.current.getSharedProperty("sharedPropertyName");
			trace( "Main.shareProperty()", receivedProperty );
			
			sendChannel = Worker.current.getSharedProperty("incomingChannel");
			// In the sending worker swf 
			sendChannel.send("This is a message");
		}
		
		protected function onFrame(e:Event):void
		{
			trace( "BgWorker.onFrame(e)", i++ );
		}
	}
}
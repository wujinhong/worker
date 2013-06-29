package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.system.WorkerState;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class Main extends Sprite
	{
		[Embed(source="../bin-debug/BgWorker.swf", mimeType="application/octet-stream")]
		private static var BgWorker_ByteClass:Class; 
		private var i:int;
		private var tf:TextField;
		private var bgWorker:Worker;
		private var shareObject:String;
		private var incomingChannel:MessageChannel;
		
		public function Main()
		{
			createWorker();
			tf = new TextField();
			addChild( tf );
			
			addEventListener( Event.ENTER_FRAME, onFrame );
		}
		
		protected function onFrame(e:Event):void
		{
			tf.text = String(i++);
		}	
		
		private function createWorker():void 
		{ 
			var workerBytes:ByteArray = new BgWorker_ByteClass(); 
			bgWorker = WorkerDomain.current.createWorker( workerBytes ); 
			// ... set up worker communication and start the worker 
			
			// listen for worker state changes to know when the worker is running 
			bgWorker.addEventListener(Event.WORKER_STATE, workerStateHandler); 
			// set up communication between workers using 
			// setSharedProperty(), createMessageChannel(), etc. 
			// ... (not shown) 
			shareProperty();
			bgWorker.start(); 
		}
		
		private function workerStateHandler(event:Event):void 
		{
			if (bgWorker.state == WorkerState.RUNNING) 
			{ 
				setTimeout( bgWorker.terminate, 1000 );
			} 
		}
		private function shareProperty():void
		{
			shareObject = "I love here Main.as";
			// code running in the parent worker 
			Worker.current.setSharedProperty( "sharedPropertyName", shareObject );
			// code running in the background worker 
		}
		
		private function messageChannel():void
		{
			// In the receiving worker swf 
			incomingChannel = Worker.current.getSharedProperty("incomingChannel");
			incomingChannel.addEventListener(Event.CHANNEL_MESSAGE, handleIncomingMessage);
		}
		
		private function handleIncomingMessage(event:Event):void 
		{
			var message:String = incomingChannel.receive() as String;
			trace( "Main.handleIncomingMessage(event)", message );
		}
	}
}
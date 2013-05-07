package  com.emotion {
	
	import flash.display.*;
	import flash.utils.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;
	import com.adobe.serialization.json.JSON;
	import flash.system.Security;
	import com.emotion.util.Global;
	import flash.system.*;
	import flash.text.TextField;

	public class Main extends Sprite{
		
        private var _host:String="127.0.0.1";
        private var _port:Number = 3503;	
		
		private var _socket:Socket;
		private var _textField:TextField;
		private var _response:String;
		
		public function Main() {			
			Security.loadPolicyFile("http://"+_host+":3800/crossdomain.xml");
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");	
			addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
		}
		
		private function _onAddedToStage(aEvent : Event):void {
			stage.removeEventListener(MouseEvent.CLICK, _onAddedToStage);
			_textField = new TextField ();
			_textField.width = 800;
			_textField.height = 300;
			_textField.multiline = true;
			_textField.htmlText = "hh";
			addChild(_textField);			
			
			this._socket = new Socket();
            this._socket.addEventListener(Event.CONNECT, onConnected);
            this._socket.addEventListener(Event.CLOSE, onClose);
            this._socket.addEventListener(ProgressEvent.SOCKET_DATA, onDataReceived);
            this._socket.addEventListener(IOErrorEvent.IO_ERROR, onError);
            this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);			
			this._socket.connect(this._host, this._port);
		}
		
		private function _onKeyUp(evt:KeyboardEvent):void{
			var json:String = JSON.encode( { event:evt.keyCode } );
			Global.trazer("manda a flash a server " + json);
			this._socket.writeUTFBytes(json);
			this._socket.flush();				
		}
		
		private function onConnected(aEvent : Event):void {
			Global.trazer("_onConnected " +aEvent );
			stage.addEventListener(KeyboardEvent.KEY_UP,_onKeyUp);
		}
		
		private function onError(event:IOErrorEvent):void {
			Global.trazer("ioErrorHandler: " + event);
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void {
			Global.trazer("securityErrorHandler: " + event);
		}		
		
		private function onDataReceived(aEvent : ProgressEvent):void{
			try {
				while (this._socket.bytesAvailable) {
					var str:String = this._socket.readUTFBytes(this._socket.bytesAvailable);
					var response:Object = JSON.decode(str);
					
					switch (response.event) {
						case "sendPid":
							//Global.pid = response.pid;
							Global.trazer("sendPid " + response.pid);
						break;
						case "ronald":
							Global.trazer("ronald se efjecuta en el cliente " );
						break;						
						default:
					}
					
				}
			} catch (error : Error) {
				Global.trazer("_onDataReceived error:  " + error);
			}
		}	
		
        private function onClose(event:Event):void {
            try {
                this._socket.close();
            } catch(error:Error) {
                Global.trazer(error.message);
            }
        }		
		
        private function destory():void {
            this._socket.removeEventListener(Event.CONNECT, onConnected);
            this._socket.removeEventListener(Event.CLOSE, onClose);
            this._socket.removeEventListener(ProgressEvent.SOCKET_DATA, onDataReceived);
            this._socket.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            this._socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
            this._socket = null;
        }	 			
	}

}
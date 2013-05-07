var net = require('net');
var port = 3507;
var host = "127.0.0.1";
var clients = new Array();
var rooms = new Array();

var myConn;

var server = net.createServer(onCreateServer);
    function onCreateServer(conn) {
        console.log(">>>>>>>>>>>>>>>>>>server conectado>>>>>>>>>>>>>>>>>>>>>>>>");
        myConn = conn;
        myConn.setEncoding('utf8');
        myConn.on("connect", onConnect);
        myConn.on("data", onData);
        myConn.on('end', onEnd);
        //rooms.push({name: "default",pass:"",num_of_player:"",mode:"box",parent: 0});
    }
        function onConnect(){
           console.log("Connected to Flash");
           clients.push({pid: generateId(),name:"", enchufe: myConn});
           var sendpid = JSON.stringify({pid: generateId(),event: "add_user"});
           myConn.write(sendpid, 'utf8');
        }
        function onData(d){
           var obj = JSON.parse(d);
           console.log("From Flash = " + obj.event+" clients  "+clients);
           var sendronald = JSON.stringify({event: "ronald"});
           myConn.write(sendronald, 'utf8');
        }
        function onEnd() {
            console.log('server desconectada');
        }
server.listen(port, host,onListen);

function onListen() { //'listening' listener
  console.log('------------servidor vinculado--------');
}

server.on('error', onError);
function onError(e) {
  if (e.code == 'EADDRINUSE') {
    console.log('Direccion en uso, volver a intentar ...');
    setTimeout(function () {
       console.log('close'); 
       server.close();
       server.listen(port, host)
    }, 1000);
  }
}

// unique id generator
function generateId(){
    var S4 = function(){
       return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    };
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
}

console.log('excecute node js');

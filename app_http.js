var express  = require('express'),
    app      = express(),
    server   = require('http').createServer(app),
    port     = 3800;

server.listen(port);
 
app.use("/css", express.static(__dirname + '/public/css'));
app.use("/js", express.static(__dirname + '/public/js'));
app.use("/imgs", express.static(__dirname + '/public/imgs'));
app.use("/swfs", express.static(__dirname + '/public/swfs'));
app.use("/xmls", express.static(__dirname + '/public/xmls'));

app.get('/', function (req, res) {
    res.sendfile(__dirname + '/public/index.html');
});
app.get('/crossdomain.xml', function (req, res) {
    res.sendfile(__dirname + '/public/xmls/crossdomain.xml');
});
app.get('/main.swf', function (req, res) {
    res.sendfile(__dirname + '/public/main.swf');
})
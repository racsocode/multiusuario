var net = require("net"),
domains = ["*:*"]; 

net.createServer(
    function(socket){
        socket.write("<?xml version=\"1.0\"?>");
        socket.write("<!DOCTYPE cross-domain-policy SYSTEM \"http://www.macromedia.com/xml/dtds/cross-domain-policy.dtd\">\n");
        socket.write("<cross-domain-policy>\n");
        domains.forEach(
            function(domain){
                var parts = domain.split(':');
                socket.write("<allow-access-from domain=\""+parts[0]+"\"to-ports=\""+(parts[1]||'80')+"\"/>\n");
            }
        );
        socket.write("</cross-domain-policy>\n");
        require("sys").log("Wrote policy file.");
        socket.end();
    }
).listen(843);
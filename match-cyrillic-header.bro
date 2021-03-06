@load base/protocols/http/main
@load base/frameworks/notice

module HTTP;

export {
    redef enum Notice::Type += {
        ## raised once per host per 10 min
        Bad_Header
    };

    global bad_header: set[addr] &create_expire = 10 min;
}

event http_header(c: connection, is_orig: bool, name: string, value: string) &priority=3
  {
     if ( name == "CONTENT-TYPE" && value == "text/html; charset=win-1251" )
     {  
     if ( c$id$orig_h !in bad_header )
     {
        add bad_header[c$id$orig_h];
        NOTICE([$note=HTTP::Bad_Header,
         $msg=fmt("Bad header \"%s\" seen in %s", value,c$uid),
         $sub=name,
         $conn=c,
         $identifier=fmt("%s", c$id$orig_h)]);


        print fmt("%s :name:value:  %s:%s",c$uid,name,value);
     }
     }
  }

@RestResource(urlMapping='/RemoteRestSvc/*')
global with sharing class RemoteRestSvcController {

@HttpGet
    global static void getStuff() {
      // ExternalService?callback=mycallback&wait=0&serverError=false&type=
      RestResponse res = RestContext.response;

      String serverError = RestContext.request.params.get('serverError');
      if(serverError=='true'){
        res.statusCode = 999; //using a code other than expected lets sfdc return 500 and response you would not get otherwise
      }
      String waitString = RestContext.request.params.get('wait');
      Integer wait = Integer.valueOf(waitString);
      String waited = '0';
      if (wait > 0){
          waited = sleep(wait);
      }

      String type = RestContext.request.params.get('type');

      String body = getData(type);

      if(type == 'JSONP'){
        String callback = RestContext.request.params.get('callback');
        res.addHeader('Content-Type', 'application/javascript');
        res.responseBody = Blob.valueOf(callback + '('+body+')');
//      res.responseBody = Blob.valueOf(callback + '({ "foo": "from Apex Rest. waited:'+waited+'" })');
      }
      else if (type == 'CORS'){
        res.responseBody = Blob.valueOf(body);
        res.addHeader('Access-Control-Allow-Origin', 'https://c.na31.visual.force.com');
        res.addHeader('Content-Type', 'application/json');
      }
      else{
          res.addHeader('Content-Type', 'text');
          res.responseBody = Blob.valueOf('<a href="'+Label.External_Service_Url+'&type=JSONP&callback=myCallback&wait=0">/RemoteRestSvc?callback=myCallback&type=JSONP</a>');
      }
    }
/*----------*/
    private static string getData(String type){
      String recordsJSON;
      if(type == 'JSONP'){
        List<Case> cases = [SELECT id, subject, contact.name,priority FROM Case where priority='High' LIMIT 2];
        recordsJSON = JSON.serializePretty(cases);
      }
      else{
        recordsJSON='{"data": [["Laurel Meyer","System Architect","Edinburgh","5421","2011/04/25","$320,800"         ],         ["Marley Paige","Accountant","Tokyo","8422","2011/07/25","$170,750"         ]]}';
      }

      return recordsJSON;
    }

    global static string sleep(Integer sleepSeconds) {
      Long startTS = System.currentTimeMillis();
      HttpRequest req = new HttpRequest();
      req.setTimeout(60000); //ms timeout limit
      req.setEndpoint('http://1.cuzillion.com/bin/resource.cgi?sleep=' + sleepSeconds);
      req.setMethod('GET');
      Http http = new Http();
      HTTPResponse res = http.send(req);
      Long duration = System.currentTimeMillis() - startTS;
      return 'Duration: ' + duration + 'ms';
    }

}

/*
https://df15-javascript-developer-edition.na31.force.com/services/apexrest/ExternalService?callback=mycallback&wait=0&serverError=false
*/
@RestResource(urlMapping='/RemoteRestSvc/*')
global with sharing class RemoteRestSvcController {

@HttpGet
    global static void getStuff() {
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
      String callback = RestContext.request.params.get('callback');
      res.addHeader('Content-Type', 'application/javascript');

      String body = getData('NA');
      res.responseBody = Blob.valueOf(callback + '('+body+')');
//      res.responseBody = Blob.valueOf(callback + '({ "foo": "from Apex Rest. waited:'+waited+'" })');
    }
/*----------*/
    private static string getData(String Param){
      List<Account> accounts = [SELECT id, name FROM Account LIMIT 2];
      String accountsJSON = JSON.serializePretty(accounts);
      return accountsJSON;
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
https://df15-javascript-developer-edition.na31.force.com/services/apexrest/RemoteRestSvc?callback=mycallback&wait=0&serverError=false
*/
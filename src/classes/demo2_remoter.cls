global with sharing class demo2_remoter {

    public demo2_remoter() { } // empty constructor
    
    @RemoteAction
    global static String updateAccounts(String accounts) {
      string ReturnString = String.valueof(System.now());
      system.debug('robots or what? '+accounts);
//      String accounts = '[{"Id":"0011a000003SPPU","Site":"stat1"},{"Id":"0011a000003SPPT","Site":"stat2"}]';
      System.debug(accounts);
      List<Account> deserializedAccounts =(List<Account>)JSON.deserialize(accounts, List<Account>.class);
      try{
        update deserializedAccounts;
      }catch(exception e){
        returnString += ' exception:'+e;
      }
      return returnString;
    }
}
global with sharing class demo2_remoter {

    public demo2_remoter() { } // empty constructor
    
    @RemoteAction
    global static String updateAccounts(String accounts) {
      string ReturnString = String.valueof(System.now());

      List<Account> deserializedAccounts =
                        (List<Account>)JSON.deserialize(accounts, List<Account>.class);
      try{
        update deserializedAccounts;
      }catch(exception e){
        returnString += ' exception:'+e;
      }
      return returnString;
    }
}
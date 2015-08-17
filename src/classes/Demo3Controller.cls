public with sharing class Demo3Controller {
  public String controllerVariable {get;set;}
  private List<String> controllerList;
  private Map<Integer, String> controllerMap;
  class someComplexInnerClass {
    String noProblem;
    List<Datetime> okay;
    Map<String, List<
      Map
        <Integer, Account> > > areYouKidding;
  }
  private someComplexInnerClass complexInstance;
  // This is a very convenient way to get arbitrarily complex values from the controller into Javascript
  public String controllerListAsJSON {get { return JSON.serialize(controllerList); }}
  public String controllerMapAsJSON {get { return JSON.serialize(controllerMap); }}
  public String complexInstanceAsJSON {get { return JSON.serialize(complexInstance); }}

	public Demo3Controller() {
    controllerVariable = 'From the controller';
    controllerList = new List<String> {'String 1', 'String 2', 'String 3', 'String 4'};
    controllerMap = new Map<Integer, String> {5 => 'Five', 7 => 'Seven', 12 => 'Twelve'};
    complexInstance = new someComplexInnerClass();
    complexInstance.noProblem = 'That was easy!';
    complexInstance.okay = new List<Datetime> {Datetime.now(), Datetime.now().addHours(-1)};
    List<Account> accts = [Select Name, Website FROM Account LIMIT 10];
    complexInstance.areYouKidding = new Map<String, List< Map<Integer, Account>>> {
      'first' => new List< Map<Integer, Account>>{
          new Map<Integer, Account> {
            4 => accts[3],
            6 => accts[5]
          },
          new Map<Integer, Account> {
            1 => accts[0],
            3 => accts[2]
          },
          new Map<Integer, Account> {
            7 => accts[6],
            10 => accts[9]
          }
        },
      'second' => new List< Map<Integer, Account>>{},
      'third' => new List< Map<Integer, Account>>{}
    };
	}
}
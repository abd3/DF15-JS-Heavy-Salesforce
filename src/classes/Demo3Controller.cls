public with sharing class Demo3Controller {
  public String controllerVariable {
    get {
      return 'From the controller';
    }
  }
  public List<String> controllerList {get;set;}

	public Demo3Controller() {
    controllerList = new List<String> {'String 1', 'String 2', 'String 3', 'String 4'};
	}
}
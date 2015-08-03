global with sharing class demo1Controller {
  public demo1Controller() {

  }

  @RemoteAction
  global static void asynchronousMethod() {
    system.debug('Do something');
  }
}
public class IncomingSMSFlowLauncher {

  @InvocableMethod(Label='Incoming SMS Flow' Description='re-Launches the Incoming SMS Flow.' Category='Apex actions')
  public static void reLaunch() {
    Map<String, Object> params = new Map<String, Object>();
    Flow.Interview.Incoming_SMS_Alert incomingSMSFlow = new Flow.Interview.Incoming_SMS_Alert(params);
    incomingSMSFlow.start();
  }

}
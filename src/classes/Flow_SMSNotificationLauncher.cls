/**
 * Created by jps26784 on 3/20/20.
 */

public class Flow_SMSNotificationLauncher {

    @InvocableMethod(Label='SMS Notification Launcher' Description='Re-launches the SMS Notification Flow to wait for the next SMS Platform Event' Category='Apex action')
    public static void reLaunch() {
        Map<String, Object> params = new Map<String, Object>();
        Flow.Interview.SMS_Notifications smsNotificationsFlow = new Flow.Interview.SMS_Notifications(params);
        smsNotificationsFlow.start();
    }

}
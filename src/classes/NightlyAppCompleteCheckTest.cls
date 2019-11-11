/**
 * Created by ejc84332 on 11/8/19.
 */

@IsTest
private class NightlyAppCompleteCheckTest {
    @IsTest
    static void testBehavior() {

        String CRON_EXP = '0 0 1 * * ?';
        NightlyAppCompleteCheck n = new NightlyAppCompleteCheck();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = 'NightlyAppCompleteCheck2' + dateString + randomInt;
        System.schedule(uniqueName, CRON_EXP, n);


    }
}
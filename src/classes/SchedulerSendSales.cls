global class SchedulerSendSales implements Schedulable{

    /*correr por consola para activar el batch:
        system.schedule('DM Cron Reenvio de Ventas con respuesta erronea - X:00', '0 0 * * * ?', new SchedulerSendSales());
        system.schedule('DM Cron Reenvio de Ventas con respuesta erronea - X:15', '0 15 * * * ?', new SchedulerSendSales());
        system.schedule('DM Cron Reenvio de Ventas con respuesta erronea - X:30', '0 30 * * * ?', new SchedulerSendSales());
        system.schedule('DM Cron Reenvio de Ventas con respuesta erronea - X:45', '0 45 * * * ?', new SchedulerSendSales());
    */
    /*public static void start() {
        System.schedule('SchedulerSendSales', CRON_EXP, new SchedulerSendSales());
    }*/
    
    global void execute(SchedulableContext SC) {
        send(); 
    }
    
    public void send() {
        Database.executeBatch( new BatchApexSendSales(),50);
        System.debug(LoggingLevel.INFO, 'Fecha y hora actual: ' + Datetime.now()); 
    }
}
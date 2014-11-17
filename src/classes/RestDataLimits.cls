@RestResource(urlMapping='/mass_post/*')
global class RestDataLimits {
    @HttpPost
    global static Result doPost(List<Account> accs) {
        insert accs;
        return new Result('Succeed', accs);
    }

    global class Result {
        global String message {get; set;}
        global List<Account> accs {get; set;}
        global Result(String m, List<Account> a) {
            this.message = m;
            this.accs = a;
        }
    }
}
public without sharing class ControllerLoginPage {
    public Student__c student {get;set;}
    public String token {get;set;}
    
    public ControllerLoginPage(){
        generateToken();
        student = new Student__c();
    }
    
    public String generateToken(){
        final String chars = 'ABCDEFGHIJKLMNOPRSTUVWXZ0123456789';
        token = '';
        while(token.length() < 15) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            token+= chars.substring(idx, idx+1);
        }
        return token;
    }

    public PageReference backHomePage(){
        return Page.HomePage;
    }
    public PageReference login(){
        Cookie access_token = new Cookie('access_token',token,null,86400,false);
      ApexPages.currentPage().setCookies(new Cookie[]{access_token});
      System.debug(access_token);
        if ((student.Email__c == null) || (student.password__c == null))
        {        
            ApexPages.message msgName = new ApexPages.message(ApexPages.severity.FATAL,'Invalid email or password ');
            ApexPages.addmessage(msgname);
        }
        
        List<Student__c> students = [
            SELECT Id,
            		Email__c,
            		password__c
            FROM Student__c
        ];
        for(Student__c loginStudent : students) {
            if ((loginStudent.Email__c == student.Email__c) && (loginStudent.Password__c == student.Password__c))
            {
                loginStudent.token__c = token;
                update loginStudent;
                
                PageReference page = Page.StudentInfo;
                page.getParameters().put('Id', loginStudent.Id);
                page.setRedirect(true);
                return page;
            }
            else {
                ApexPages.message msgName = new ApexPages.message(ApexPages.severity.FATAL,'Invalid email or password ');
            ApexPages.addmessage(msgname);
            }
        }
        return null;
    }
    public PageReference goRegistration(){
        return Page.RegistrationOnSite;
    }
}
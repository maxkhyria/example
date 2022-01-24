public without sharing class ControllerRegistrationOnSite {
    public Student__c addStudent {get;set;}
    public ControllerRegistrationOnSite(){
        addStudent = new Student__c();
    }
    
    public static Boolean validateEmail(String email) {
        Boolean res = true;
        
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        
        if (!MyMatcher.matches()) 
            res = false;
        return res;	
    }
    
    public PageReference addStudent(){
        if((addStudent.name != null) && (addStudent.password__c != null) && (addStudent.email__c != null)){
            if(validateEmail(addStudent.email__c)){
                try {
                    insert addStudent;
                    return Page.LoginPage; 
                } catch (DMLException e) {
                    ApexPages.message msgName = new ApexPages.message(ApexPages.severity.FATAL,'Email already exists!');
                    ApexPages.addmessage(msgname);
                }
            }
            else {
                ApexPages.message msgName = new ApexPages.message(ApexPages.severity.FATAL,'Invalid email ');
                ApexPages.addmessage(msgname);
            }
        }
        else {
            ApexPages.message msgName = new ApexPages.message(ApexPages.severity.FATAL,'Enter all fields ');
            ApexPages.addmessage(msgname);
        }
        return null;
    }
    
    public PageReference backToLogin(){
        return Page.LoginPage;
    }
}
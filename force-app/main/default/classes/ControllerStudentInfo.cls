public without sharing class ControllerStudentInfo {
    public List<Books__c> books {get;set;}
    public Student__c student {get;set;}
    Id idStud = ApexPages.currentPage().getParameters().get('id');
    public String selectedBook {get;set;}
    List<selectOption> options {get;set;}
    
    public ControllerStudentInfo (){
            student = [
            SELECT  id,
                	token__c,
            		Name,
            		Email__c
            FROM Student__c
            WHERE id = :idStud
        ];
    }
    
    public String getToken() {
        Cookie token = ApexPages.currentPage().getCookies().get('access_token');
        if(token == null) {
            return '0';
        } 
        return token.getValue();
    }
    
    public PageReference checkAccessToken(){
        if(student.token__c != getToken()) {
            return Page.LoginPage;
        }
        return null;
    }
    
    public PageReference logOut(){
        student.token__c = '';
        update student;
        return Page.LoginPage;
    }
    
	public List<selectOption> getBookStudent() {
        options = new List<selectOption>();
		for(Books__c book : [ 
                SELECT  Name,
                        Student__r.Id
                FROM Books__c
                WHERE Student__r.Id = :idStud
            ]) 
        {
			options.add(new selectOption(book.Name,book.Name));
		}
		return options;
	}

    public void deleteBook(){
      Books__c b = [
            SELECT Id
            FROM Books__c
            WHERE Name = :selectedBook
        ];
        try{
            delete b;
        } catch (Exception e) {
            ApexPages.message msgBook = new ApexPages.message(ApexPages.severity.FATAL,'Enter book');
                ApexPages.addmessage(msgBook);
        }
    }
}
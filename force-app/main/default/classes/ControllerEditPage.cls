public without sharing class ControllerEditPage {  
    public Student__c std {get;set;}
    public List<Books__c> bookList {get;set;}
    public String selectedBook {get;set;}
    List<selectOption> options {get;set;}
    public Books__c addBook {get;set;}
	Id idStud = ApexPages.currentPage().getParameters().get('id');  
    
    public ControllerEditPage (){
        addBook = new Books__c();
        std = [
            SELECT  id,
            		Name,
            		Email__c,
            		(SELECT id,Date_of_issue__c,Name,Return_data__c FROM Student__r)
            FROM Student__c
            WHERE Id = :idStud
        ];
    }
    
    public void addBook(){
       addBook.Student__c = idStud;
        if(addBook.Name != null){
          insert addBook;
		addBook = new Books__c();  
        }
        else {
            ApexPages.message msgBook = new ApexPages.message(ApexPages.severity.FATAL,'Enter name book');
                ApexPages.addmessage(msgBook);
        }
               
    }
    
    public List<Books__c> getBooksList(){
       bookList = [
            SELECT  id,
            		Name,
            		Date_of_issue__c,
            		Return_data__c,
            		Student__r.id
            FROM Books__c
            WHERE Student__r.id =:idStud
        ];
        return bookList;
    }
    
    public List<selectOption> getBookStudent() {
        options = new List<selectOption>();
		for(Books__c book : [ SELECT Name,Student__r.Id
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
    
    public void edit(){
        update std;
        update bookList;
    }
    
    public PageReference goBack(){
        return Page.MainPage;
    }
}
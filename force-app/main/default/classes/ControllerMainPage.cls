public without sharing class ControllerMainPage {
   
    public Student__c studentAdd {get;set;}
    public String idStudent {get;set;}
    public Books__c book {get;set;}
    public List<Books__c> bookList {get;set;}
    
    public ControllerMainPage (){
        studentAdd = new Student__c();
        book = new Books__c();
    }
    public PageReference backHomePage(){
        return Page.HomePage;
    }
    
    public void studentInfo(){
        bookList = [
            SELECT  Name,
            		Student__r.Id,
            		Return_data__c,
            		Date_of_issue__c
            FROM Books__c
            WHERE Student__r.Id = :idStudent
        ];
    }
    
    public void save(){
        if(studentAdd.Name == null) {
            ApexPages.message msgName = new ApexPages.message(ApexPages.severity.FATAL,'Please enter name');
            ApexPages.addmessage(msgname);
        }
        else if(book.Name == null) {
            ApexPages.message msgBook = new ApexPages.message(ApexPages.severity.FATAL,'Please enter book');
            ApexPages.addmessage(msgBook);
        }
        else 
        {
            try{
                insert studentAdd;
                book.Student__c = studentAdd.id;
                insert book;
                studentAdd = new Student__c();
                book = new Books__c();
            } catch (Exception e){
                ApexPages.message msgBook = new ApexPages.message(ApexPages.severity.FATAL,'Email already exists');
                ApexPages.addmessage(msgBook);
            }
        }
    }
    
    public List<WrapperStudent> getStudents(){
        List<WrapperStudent> wrapStudents = new List<WrapperStudent>();
        List<Student__c> studentsList = [
            SELECT  id,
            		Name,
                    Email__c,
                    Password__c,
                    (SELECT Name,Return_data__c,Date_of_issue__c FROM Student__r)
            FROM Student__c
        ];
        for(Student__c std : studentsList)
        {
            wrapStudents.add(new WrapperStudent(std));
        }
        return wrapStudents; 
    }
   
    public void deleteStudent(){
        Student__c s = [
            SELECT id,(SELECT Name FROM Student__r)
            FROM Student__c
            WHERE Id = :idStudent
        ];
        try{
            delete s;
        } catch (Exception e) {
            ApexPages.message msgBook = new ApexPages.message(ApexPages.severity.FATAL,'Student have not return books');
                ApexPages.addmessage(msgBook);
        }
    }
    
    public class wrapperStudent {
        public String password {get;set;}
        public String Email {get;set;}
        public ID StudentId {get;set;}
        public String Name {get;set;}
      
        public wrapperStudent(Student__c ct){
            this.password = ct.Password__c;
            this.Email = ct.Email__c;
            this.StudentId = ct.Id ;
            this.Name = ct.Name;
        }
    }
  
}
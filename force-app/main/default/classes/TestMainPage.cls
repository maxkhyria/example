@isTest
public class TestMainPage {
    @testSetup static void setup() {
        list<Books__c> listBooks = new list<Books__c> {
            new Books__c (Name = 'testBook',Return_data__c = date.newInstance(2022,28,1),Date_of_issue__c = date.newInstance(2022,24,1)),
                new Books__c (Name = 'testBook2',Return_data__c = date.newInstance(2022,30,1),Date_of_issue__c = date.newInstance(2022,20,1))
                };
                    insert listBooks;
        
        list<Student__c> listStud = new list<Student__c> {
            new Student__c (name = 'test',Email__c = 'test@test.ru', Password__c = '1111'),
                new Student__c (name = 'test2',Email__c = 'test2@test.ru',Password__c = '2222')
                };
                    insert listStud;
        
        Student__c student = new Student__c(Name = 'testStudent');
        insert student;
        Books__c book = new Books__c(Name = 'testBook',Student__c = student.id);
        insert book;
    }

    @isTest
    public static void testSave() {
        PageReference pageRef = Page.MainPage;
        Test.setCurrentPage(pageRef);
        ControllerMainPage controller = new ControllerMainPage();
        controller.studentAdd.Name = 'testInSave';
        controller.book.Name = 'testBookInSave';
        
        Test.startTest();
        controller.save();
        Test.stopTest();
        
        List<Student__c> s = [SELECT Name FROM Student__c WHERE Name = 'testInSave'];
        System.assertEquals(1,s.size());
        List<Books__c> b = [SELECT Name FROM Books__c WHERE Name = 'testBookInSave'];
        System.assertEquals(1,b.size());
        }

    @isTest
    public static void testSaveFail() {
        PageReference pageRef = Page.MainPage;
        Test.setCurrentPage(pageRef);
        ControllerMainPage controller = new ControllerMainPage();
        controller.studentAdd.Name = null;
        controller.book.Name = null;
        
        Test.startTest();
        controller.save();
        Test.stopTest();
        
        List<Student__c> s = [SELECT Name FROM Student__c WHERE Name = : controller.studentAdd.Name];
        System.assertEquals(0,s.size());
        List<Books__c> b = [SELECT Name FROM Books__c WHERE Name = :controller.book.Name];
        System.assertEquals(0,b.size());
        }

    @isTest
    public static void testGetStudent() {
        PageReference pageRef = Page.MainPage;
        Test.setCurrentPage(pageRef);
        ControllerMainPage controller = new ControllerMainPage();
        controller.getStudents(); 
    }

    @isTest
    public static void testDeleteStudentTrue() {
        PageReference pageRef = Page.MainPage;
        Test.setCurrentPage(pageRef);
        ControllerMainPage controller = new ControllerMainPage();
        Student__c std = [SELECT id FROM Student__c WHERE name = 'test'];
        controller.idStudent = std.Id;
        
        Test.startTest();
        controller.deleteStudent();
        Test.stopTest();
        List<Student__c> stdl = [SELECT id FROM Student__c WHERE name = 'test'];
        System.assertEquals(0, stdl.size());
    }

    @isTest
    public static void testDeleteStudentFalse() {
        PageReference pageRef = Page.MainPage;
        Test.setCurrentPage(pageRef);
        ControllerMainPage controller = new ControllerMainPage();
        Student__c std = [SELECT id FROM Student__c WHERE name = 'testStudent'];
        controller.idStudent = std.Id;
        
        Test.startTest();
        controller.deleteStudent();
        Test.stopTest();
        List<Student__c> stdl = [SELECT id FROM Student__c WHERE name = 'testStudent'];
        System.assertEquals(1, stdl.size());
    }

    @isTest
    public static void studentInfo() {
        PageReference pageRef = Page.MainPage;
        Test.setCurrentPage(pageRef);
        ControllerMainPage controller = new ControllerMainPage();
        
        controller.studentInfo();
        
        Student__c std = [SELECT id FROM Student__c WHERE name = 'testStudent'];
        controller.idStudent = std.Id;
        
        List<Books__c> bookList = [
            SELECT  Name,
            		Student__r.Id,
            		Return_data__c,
            		Date_of_issue__c
            FROM Books__c
            WHERE Student__r.Id = :controller.idStudent
        ];
        System.assertEquals(1, bookList.size());
    }
//test coment
    @isTest
    public static void backHomePage() {
        PageReference pageRef = Page.MainPage;
        Test.setCurrentPage(pageRef);
        ControllerMainPage controller = new ControllerMainPage();
        
        controller.backHomePage();
    }
}
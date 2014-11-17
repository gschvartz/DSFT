public class Human {
    public class Student {
        public String studentId         {get; set;}
        public String name              {get; set;}
        public String birthday          {get; set;}
        public String cellphone         {get; set;}
    }

    public class Teacher {
        public String studentId         {get; set;}
        public String name              {get; set;}
        public String birthday          {get; set;}
        public String cellphone         {get; set;}
        public String course            {get; set;}
        public String rate              {get; set;}
        public List<Student> students   {get; set;}
        // comment
    }
}
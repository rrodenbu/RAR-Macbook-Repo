/**
 * Created by rrodenbu on 5/12/16.
 */

//class is a template for creating objects
//everything should be an object
class Person { //Class always capital
    // Instance variables (data or "state")
    String name;
    int age;


    // Classes can contain
    // 1. Data (name, age, address, etc.) (instance variables)
    // 2. Subroutines (methods)
    void speak() {
        System.out.println("Hello, My name is " + name + " and I am " + age + " years old.");
    }
    void sayHello() {
        System.out.println("Hello world!");
    }
 }

class DogType {
    int age;
    String name;
}

public class Application {
    //subroutine of class Application (METHOD)
    public static void main(String[] args) {
        Person person1 = new Person();
        person1.name = "Joe Bloggs"; //instance data
        person1.age = 37; //instance data
        person1.speak(); //method
        person1.sayHello();//another method

        Person person2 = new Person();
        person2.name = "Doug Junior";
        person2.age = 8;
        person2.speak();

        System.out.println(person1.name);

        DogType dog1 = new DogType();
        dog1.age = 32;
        dog1.name = "Sargent";
    }
}

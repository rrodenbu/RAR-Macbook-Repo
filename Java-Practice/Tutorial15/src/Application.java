/**
 * Created by rrodenbu on 5/12/16.
 */

class Person {
    String name;
    int age;

    void speak() {
        System.out.println("My name is " + name);
    }

    void calculateYearsToRetirement() {
        int yearsLeft = 65 - age;
        System.out.println(yearsLeft);
    }

    int returnYearsToRetirement() { //method
        int yearsLeft = 65 - age;
        return yearsLeft;
    }

    int getAge() {
        return age;
    } //method

    String getName() {
        return name;
    } //method
}

public class Application {
    public static void main(String[] args) {
        Person person1 = new Person();

        person1.age = 37;
        person1.name = "Billy Bob";

        person1.speak();
        person1.calculateYearsToRetirement();

        int years = person1.returnYearsToRetirement();
        System.out.println("Years till retirement: " + years);

        int age = person1.getAge();
        String name = person1.getName();


    }
}

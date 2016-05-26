/**
 * Created by rrodenbu on 5/10/16.
 */
public class Application {
    public static void main(String[] args) {
        int myInt = 7;

        String text = "Hello."; //Not premitive, is a class (i.e. capital 'S')

        String blank = " ";

        String name = "Bob";

        String greeting = text + blank + name;

        System.out.println(text);
        System.out.println(greeting);
        System.out.println("Bob" + "Hello");
        System.out.println("My number is " + myInt);


    }
}

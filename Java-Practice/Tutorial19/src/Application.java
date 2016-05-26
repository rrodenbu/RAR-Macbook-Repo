/**
 * Created by rrodenbu on 5/23/16.
 */
class Thing {
    public final static int LUCKY_NUMBER = 7; //final = CONSTANT (can't reassign)

    //usually private or protected
    public String name; //instance variable
    public static String description; //static variable; class variable; same for all objects

    public static int count = 0; //static: attached to class not specific object

    public int id; //Instance variable; Initialize default to 0 in JAVA

    public Thing() { //counts number of objects when created
        id = count;
        count++;
    }

    public void showName() { //instance Method
        System.out.println("INSTANCE METHOD: " + description + ":" + name);
    }

    public static void showInfo() { //Static Method; Can access static data.
        System.out.println("STATIC METHOD: ");
        System.out.println(description);
    }
}

public class Application {
    public static void main(String[] args) {

        Thing.description = "I am a thing";

        System.out.println(Thing.description);

        Thing.showInfo();

        Thing thing1 = new Thing();
        Thing thing2 = new Thing();

        thing1.name = "Bob";
        thing2.name = "Joe";

        //System.out.println(thing1.name);
        //System.out.println(thing2.name);

        thing1.showName();
        thing2.showName();

        System.out.println("PI: " + Math.PI);

        System.out.println("CONSTANT: " + Thing.LUCKY_NUMBER);

        System.out.println("Number of objects created: " + Thing.count);

        System.out.println("Object 1 ID: " + thing1.id);

        System.out.println("Object 2 ID: " + thing2.id);
    }
}

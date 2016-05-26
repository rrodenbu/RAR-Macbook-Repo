/**
 * Created by rrodenbu on 5/23/16.
 */
class Machine {
    private String name;
    int code;

    public Machine() { //Normally method is lower case, but it's constuctor so has same name as class
        this("Arnie", 0); //constructor calling constructor
        System.out.println("Constructor 1  running!");
        name = "Arnie";

    }//CONSTRUCTOR: no return type(not even void); creates new object

    public Machine(String name) { //Can have multiple constuctors with same name as long as they have different parameters

        System.out.println("Constructor 2 running!");
        this.name = name;
    }

    public Machine(String name, int code) {

        System.out.println("Constructor 3 running!");
        this.name = name;
        this.code = code;
    }
}

public class Application {
    public static void main(String[] args) {
        Machine machine1 = new Machine();
        new Machine(); //will also create a new object

        Machine machine2 = new Machine("Bob");

        Machine machine3 = new Machine("Bill", 3);
    }
}

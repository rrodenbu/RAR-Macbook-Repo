/**
 * Created by rrodenbu on 5/24/16.
 */
public class Machine {

    //private String name = "Machine Type 1";
    String name = "Machine Type 1"; //Accessible anywhere in package
    protected String name2 = "Machine Type 2"; //Accesible anywhere in package and chile class.

    public void start() {
        System.out.println("Machine started.");
    }

    public void stop() {
        System.out.println("Machine stopped.");
    }

}

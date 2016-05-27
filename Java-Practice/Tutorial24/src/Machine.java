/**
 * Created by rrodenbu on 5/26/16.
 */
public class Machine implements Info{ //Implements = interface

    private int id = 7;

    public void start() {
        System.out.println("Machine Started.");
    }

    @Override
    public void showInfo() {
        System.out.println("Machine ID is: " + id);
    }
}

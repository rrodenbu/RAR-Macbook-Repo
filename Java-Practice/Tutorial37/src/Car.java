/**
 * Created by rrodenbu on 5/27/16.
 */
public class Car extends Machine {

    @Override
    public void start() {
        System.out.println("Car started.");
    }

    @Override
    public void doStuff() {
        System.out.println("Do stuff in Car.");
    }

    @Override
    public void shutdown() {
        System.out.println("Turn car off.");
    }

}

/**
 * Created by rrodenbu on 5/27/16.
 */
public class Camera extends Machine {

    @Override
    public void start() {
        System.out.println("Camera started.");
    }

    @Override
    public void doStuff() {
        System.out.println("Do stuff with Camera.");
    }

    @Override
    public void shutdown() {
        System.out.println("Shut down camera.");
    }

}

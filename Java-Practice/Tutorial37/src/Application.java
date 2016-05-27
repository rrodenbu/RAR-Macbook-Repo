/**
 * Created by rrodenbu on 5/27/16.
 * TOPIC: Abstract Classes
 *
 * Abstract vs. Interface: Class can implement multiple interfaces
 *                         Abstract class can have codoe, while an interface can't
 */
public class Application {

    public static void main(String[] args) {

        Camera cam1 = new Camera();

        cam1.setId(5);

        Car car1 = new Car();
        car1.setId(3);

        //No need, because there is no machine just subclasses of machines.
        //Machine machine1 = new Machine(); //Can't do b/c Machine is abstract

        car1.run();

    }

}

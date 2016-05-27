/**
 * Created by rrodenbu on 5/26/16.
 * TOPIC: Upcasting and DOwncasting
 */

class Machine {
    public void start() {
        System.out.println("Machine started.");
    }
}

class Camera extends Machine {
    public void start() {
        System.out.println("Camera started.");
    }

    public void snap() {
        System.out.println("Photo taken.");
    }
}

public class Application {

    public static void main(String[] args) {

        Machine machine1 = new Machine();
        Camera camera1 = new Camera();

        machine1.start();
        camera1.start();
        camera1.snap();

        //Upcasting.
        Machine machine2 = new Camera();
        Machine machine3 = camera1;
        machine3.start();
        //machine2.snap(); //not possible.

        //Downcasting.
        Machine machine4 = new Camera();
        Camera camera2 = (Camera) machine4; //Downcasting requires confirmation
        camera2.start();
        camera2.snap();

        // Does'nt work -- runtime error.
        Machine machine5 = new Machine();
        Camera camera3 = (Camera) machine5; //Can't change camera object into machine object.
        camera3.start();
        camera3.snap();;


    }

}

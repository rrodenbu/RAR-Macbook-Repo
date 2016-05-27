/**
 * Created by rrodenbu on 5/27/16.
 * TOPIC: Anonymous Class
 */

class Machine {
    public void start() {
        System.out.println("Starting machine ... ");
    }
}

interface Plant {
    public void grow();
}

public class Application {
    public static void main(String[] args) {

        Machine machine1 = new Machine();
        Machine machine2 = new Machine() { //Anonymous Class; Child class of Machine.
          @Override public void start() {
              System.out.println("Starting machine.");
          }
        };

        machine1.start();
        machine2.start();

        Plant plant1 = new Plant(){ //Another form of Anonymous Class.
            public void grow() {
                System.out.println("Plant grew.");
            }
        };

        plant1.grow();

    }
}

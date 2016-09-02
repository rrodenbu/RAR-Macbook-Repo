/**
 * Created by rrodenbu on 5/28/16.
 * TOPIC: Try-With-Resources
 *      Simplifying exceptions. Only possible with Java7
 */

class Temp implements AutoCloseable { //Must have close method
    @Override
    public void close() throws Exception {
        System.out.println("Closing!");
    }

}

public class Application {

    public static void main(String[] args) {

        //Simpler
        try(Temp temp = new Temp()) {

        } catch (Exception e) {
            System.out.println("Can't close.");
        }

        /*
        //More complex
        Temp temp = new Temp();

        try {
            temp.close();
        } catch (Exception e) {
            System.out.println("Can't close.");
        }*/

    }

}

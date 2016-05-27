import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;

/**
 * Created by rrodenbu on 5/27/16.
 * TOPIC: Multiple Exceptions
 */
public class Application {

    public static void main(String[] args) {

        Test test = new Test();

        /*
        try { //Must use try becuase we don't want to throw out error to another class b/c we are in Main class
            test.run();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
            System.out.println("Couldn't parse command file.");
        }*/

        /*
        try { //few catches
            test.run();
        } catch (IOException | ParseException e) {
            System.out.println("ERROR!");
        }*/

        try {
            test.run();
        } catch (Exception e) { //catches anytype of exception
            e.printStackTrace();
        }

        // INTERVIEW: Must handle child exception before adult exception
        // Becuase of polymorphysm.

    }

}

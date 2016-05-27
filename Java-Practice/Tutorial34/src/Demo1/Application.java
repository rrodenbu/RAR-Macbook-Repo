package Demo1;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;

/**
 * Created by rrodenbu on 5/27/16.
 * TOPIC: Exceptions
 */
public class Application {

    public static void main(String[] args) throws FileNotFoundException {

        File file = new File("test.txt");

        FileReader fr = new FileReader(file);



    }

}

package Demo2;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;

/**
 * Created by rrodenbu on 5/27/16.
 */
public class Application {

    public static void main(String[] args) {
        File file = new File("test.txt");

        try {
            FileReader fr = new FileReader(file);

            //This will not be exectuted if an exception is thrown.
            System.out.println("Continueing...");
        } catch (FileNotFoundException e) {
            System.out.println("File not found:" + file.toString());
        }
        System.out.println("Finished.");
    }

}

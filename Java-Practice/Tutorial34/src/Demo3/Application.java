package Demo3;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;

/**
 * Created by rrodenbu on 5/27/16.
 */
public class Application {

    public static void main(String[] args) {
        try {
            openFile();
        } catch (FileNotFoundException e) {
            System.out.println("Could not open file."); //Prevents stack trace.
        }
    }

    public static void openFile() throws FileNotFoundException {
        File file = new File("test.txt");

        FileReader fr = new FileReader(file);
    }

}

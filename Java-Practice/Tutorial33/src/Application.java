import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

/**
 * Created by rrodenbu on 5/27/16.
 * TOPIC: Reading Lines
 */
public class Application {

    public static void main(String[] args) throws FileNotFoundException {

        String fileName = "/Volumes/RILEY DOCS/RAR Macbook Repo/Java-Practice/Tutorial33/textToRead.rtf";

        File textFile = new File(fileName);

        Scanner in = new Scanner(textFile);

        //int value = in.nextInt();
        //System.out.println("Read value: " + value);
        //in.nextLine();
        int count = 1;
        while(in.hasNextLine()) {
            String line = in.nextLine();
            System.out.println(count + ":" + line);
            count++;
        }

        in.close();

    }

}

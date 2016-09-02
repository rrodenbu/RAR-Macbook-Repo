import java.io.*;

/**
 * Created by rrodenbu on 5/28/16.
 * TOPIC: Reading with FileReader
 */
public class Application {

    public static void main(String[] args) {

        File file = new File("test.txt");
        BufferedReader br = null;

        try {
            FileReader fr = new FileReader(file);
            br = new BufferedReader(fr);

            String line;

            while( (line = br.readLine()) != null ) {
                System.out.println(line);
            }



        } catch (FileNotFoundException e) {
            System.out.println("File not found: " + file.toString());
        } catch (IOException e) {
            System.out.println("Unable to read file: " + file.toString());
        }
        finally { //Guranteed to be executed.
            try {
                br.close();
            } catch (IOException e) {
                System.out.println("Can't close file: " + file.toString());
            } catch (NullPointerException e) {
                System.out.println("Null pointer when closing file");
            }
        }
    }
}

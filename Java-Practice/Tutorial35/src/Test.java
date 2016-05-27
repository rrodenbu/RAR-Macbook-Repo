import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.ParseException;

/**
 * Created by rrodenbu on 5/27/16.
 */
public class Test {

    public void run() throws IOException, ParseException {

        //Can only throw one exception at a time.
        //throw new IOException();

        throw new ParseException("Error in command list.", 2);

    }

}

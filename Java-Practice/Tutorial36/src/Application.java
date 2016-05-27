/**
 * Created by rrodenbu on 5/27/16.
 * TOPIC: Runtime Exceptions
 */
public class Application {

    public static void main(String[] args) {
        //INTERVIEW: Checked exceptions: forced to handle
        //Thread.sleep(111);

        //INTERVIEW: Un-Checked (Runtime) exceptions: don't have to handle
        //Won't see until the code is compiled.

        //Arithmetic exception
        //int value = 7;
        //value = value/0;

        //Null pointer exception
        //String text = null;
        //System.out.println(text.length());

        //Array Index Out of Bounds exception.
        String[] texts = {"one", "two", "three"};
        try {
            System.out.println(texts[3]); //out of bounds
        } catch (Exception e) {
            System.out.println(e.toString());
        }

    }

}

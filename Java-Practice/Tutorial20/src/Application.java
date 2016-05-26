/**
 * Created by rrodenbu on 5/24/16.
 */
public class Application {
    public static void main(String[] args) {

        //Inefficient
        String info = "";

        info += "My name is Bob."; //Creating new string each time, whic could slow the program
        info += " ";
        info += "I am a builder.";

        System.out.println(info);

        //More efficient
        StringBuilder sb = new StringBuilder(""); //also stringBuffer(for multi-threading)
        sb.append("My name is Joe.");
        sb.append(" ");
        sb.append("I am a lion trainer.");

        System.out.println(sb.toString());

        StringBuilder s = new StringBuilder();

        s.append("My name is Roger.").append(" ")
        .append("I am a sky diver.");

        System.out.println(s.toString());

        // FORMATTING
        System.out.println("Here is some text.\t That was a tab. \nThat was a new line.");//new line

        //Formatting integers
        System.out.printf("Total %d", 5); //d: number
        System.out.printf("Two values: %d, %d", 3, 120);

        for(int i=0; i<20; i++) {
            System.out.printf("%2d: some text here \n", i); //2 width of 2 characters
            System.out.printf("%-2s: %s \n", i, "new text"); //left aligned
        }

        //Formatting floating point value
        System.out.printf("Total value: %.2f\n", 5.6790); //two decimal places with rounding
        System.out.printf("Total value: %6.1f\n", 343.234); //6 = total number of alloted spaces including decimal
    }
}

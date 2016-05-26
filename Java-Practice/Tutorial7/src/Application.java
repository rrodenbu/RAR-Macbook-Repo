import java.util.Scanner;

/**
 * Created by rrodenbu on 5/10/16.
 */
public class Application {
    public static void main(String[] args) {

        //Create scanner object
        Scanner input = new Scanner(System.in);//

        //Output the prompt
        System.out.println("Enter a line of text: ");

        //Wait for the user to enter a lin of text
        String line = input.nextLine();

        System.out.println("You entered: " + line);

        //Output next prompt
        System.out.println("Enter a integer: ");

        //Wait for the user to enter an integer
        int value = input.nextInt();

        System.out.println("You entered: " + value);
    }
}

import java.util.Scanner;

/**
 * Created by rrodenbu on 5/10/16.
 */
public class Application {
    public static void main(String[] args) {

        Scanner input = new Scanner(System.in);

        System.out.println("Please enter a command: ");
        String text = input.nextLine();

        switch (text) { //can be int or string
            case "start": //must be constant values
                System.out.println("Machine Started!");
                break;

            case "end":
                System.out.println("Machine Stopped!");
                break;

            default:
                System.out.println("Command not recognized.");
        }

    }
}

import java.util.Scanner;

/**
 * Created by rrodenbu on 5/10/16.
 */
public class Application {
    public static void main(String[] args) {
        int value = 0;
        Scanner scanner = new Scanner(System.in);

        /*
        System.out.println("Enter a number: ");
        int value = scanner.nextInt();

        while(value != 5) {
            System.out.println("Enter a number: ");
            value = scanner.nextInt();
        }*/

        do {
            System.out.println("Enter a number: ");
            value = scanner.nextInt();
        }
        while(value != 5); //Checks second.

        System.out.println("Got 5!");



    }
}

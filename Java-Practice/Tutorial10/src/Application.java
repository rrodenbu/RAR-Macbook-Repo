/**
 * Created by rrodenbu on 5/11/16.
 */
public class Application {
    public static void main(String[] args) {

        int value = 7;

        //ARRAY
        int[] values;
        values = new int[3]; //have default values

        System.out.println(values[0]);
        System.out.println(values[1]);
        System.out.println(values[2]);

        values[0] = 1;
        values[1] = 2;
        values[2] = 3;

        System.out.println(values[0]);
        System.out.println(values[1]);
        System.out.println(values[2]);

        for(int i = 0; i < values.length; i++) {
            System.out.println(values[i]);
        }

        int[] numbers = {5,6,7};//Declare and fill

        for(int i = 0; i < numbers.length; i++) {
            System.out.println(numbers[i]);
        }
    }
}

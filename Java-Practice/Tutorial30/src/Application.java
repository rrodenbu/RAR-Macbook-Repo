import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by rrodenbu on 5/26/16.
 * TOPIC: Generic Classes
 */

class Animal {

}

public class Application {

    public static void main(String[] args) {

        // Before Java 5
        ArrayList list = new ArrayList();

        list.add("apple");
        list.add("banana");
        list.add("orange");

        String fruit = (String) list.get(0); //returns an object
        System.out.println(fruit);

        // Java 5
        ArrayList<String> strings = new ArrayList<String>();

        strings.add("cat");
        strings.add("dog");
        strings.add("frog");

        String animal = strings.get(2);
        System.out.println(animal);

        // There can be more than one type argument
        HashMap<Integer, String> map = new HashMap<Integer, String>();

        // Java7
        ArrayList<Animal> someList = new ArrayList<>();


    }

}

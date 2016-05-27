import ocean.Fish; //Because in different package.
import ocean.plants.Seaweed;

//import ocean.*; //so you dont have to keep importing different methods

/**
 * Created by rrodenbu on 5/25/16.
 * Topic: Packages: Organize code & prevent class name conflicts
 */
public class Application {
    public static void main(String[] args) {

        Fish fish = new Fish();
        Seaweed seaweed = new Seaweed();

    }
}

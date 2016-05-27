import world.Plant;

/**
 * Created by rrodenbu on 5/26/16.
 * TOPIC: Public, Private, Protected
 */

/* private -- same class, only within same class
 * public -- same class, from anywhere
 * protected -- same class, subclass, and same package
 * no modifier -- same package only
 *
 */
public class Application {

    public static void main(String[] args) {

        Plant plant = new Plant();

        System.out.println(plant.name); //because name = public

        System.out.println(plant.ID);

        //System.out.println(plant.type); //won't work "type" is private

        //System.out.println(plant.size); //wont work "size" is protected and Applicaiton is not in the same package

        //won't work; Application and Plant in different packages, height has package level visibility.
        //System.out.println(plant.height);

    }

}

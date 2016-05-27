package world;

/**
 * Created by rrodenbu on 5/26/16.
 */
public class Field {

    private Plant plant = new Plant();

    public Field() {

        // "size" is protected; World.Field is in the same package as World.Plant
        System.out.println(plant.size);
    }

}

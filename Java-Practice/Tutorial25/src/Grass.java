import world.Plant;

/**
 * Created by rrodenbu on 5/26/16.
 */
public class Grass extends Plant {

    public Grass() {
        // Won't work; Grass is not in same package as plant, even though it is a subclass
        //System.out.println(this.height);
    }

}

/**
 * Created by rrodenbu on 5/26/16.
 * TOPIC: polymorphism's
 *
 */
public class Application {

    public static void main(String[] args) {

        Plant plant1 = new Plant();
        Tree tree = new Tree();

        Plant plant2 = plant1;

        Plant plant3 = tree; //Can only call functions in Plant

        plant2.grow();
        plant3.grow();

        tree.shedLeaves();
        //plant3.shedLeaves(); //Won't work; Because declared as Plant.

        doGrow(tree);
    }

    public static void doGrow(Plant plant) {
        plant.grow();
    }

}

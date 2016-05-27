/**
 * Created by rrodenbu on 5/26/16.
 */
public class Tree extends Plant {

    @Override
    public void grow() {
        System.out.println("Tree growing.");
    }

    public void shedLeaves() {
        System.out.println("Tree shedding.");
    }
}

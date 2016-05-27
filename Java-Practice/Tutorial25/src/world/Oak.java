package world;

/**
 * Created by rrodenbu on 5/26/16.
 */
public class Oak extends Plant {

    public Oak() {
        //type = "tree"; //Not possible -- "type" is private

        //Size = "protected" -- accessible any class, subclass or same package
        this.size = "large";

        // No access specifier; works because Oak and Plant in the same package
        this.height = 10;
    }

}

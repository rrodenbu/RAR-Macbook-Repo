package world;

/**
 * Created by rrodenbu on 5/26/16.
 */

//can't have private class.
    //only one public class
    //public class must have same name as file
public class Plant { //"public" visible from anywhere

    //Bad practice, should be private with getter and setter methods.
    public String name; //public: accessible anywhere.

    // Acceptable practice -- it's final
    public final static int ID = 8; //final = constant

    private String type;

    protected String size;

    int height;

    public Plant () {
        name = "Rose"; //don't need "this." but can if you want
        this.type = "plant";
        this.size = "medium";
        this.height = 7;
    }

}

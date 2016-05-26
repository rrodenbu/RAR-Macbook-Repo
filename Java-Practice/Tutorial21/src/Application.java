import java.util.Objects;

/**
 * Created by rrodenbu on 5/24/16.
 */

class Frog {

    private int id;
    private String name;

    public Frog (int id, String name) {
        this.id = id;

        this.name = name;
    }

    public String toString() {
        //return id + ": " + name;

        /*
        StringBuilder sb = new StringBuilder();
        sb.append(id).append(": ").append(name);
        return sb.toString();*/

        return String.format("%-2d: %s", id, name);
    }
}

public class Application {
    public static void main(String[] args) {
        Frog frog1 = new Frog(3, "Freddy");
        Frog frog2 = new Frog(2, "Danny");

        System.out.println(frog1);
        System.out.println(frog2);

    }
}

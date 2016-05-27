/**
 * Created by rrodenbu on 5/26/16.
 * TOPIC: Encapsulated.
 */

class Plant {

    public static final int ID = 7; //CNSTS are public
    private String name;

    public String getData() {
        String data = "some stuff" + calculateGrowthForecast();

        return data;
    }

    private int calculateGrowthForecast() { //only accessible inside this class
        return 9;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}

public class Application {

    public static void main(String[] args) {

    }

}

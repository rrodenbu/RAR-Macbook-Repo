/**
 * Created by rrodenbu on 5/24/16.
 */
public class Car extends Machine{ //Car is a child class of Machine. EXTENDED.

    public void start() { //Doesnt check to see if there is a function to override.
        System.out.println("Car started.");
    }

    @Override //Checks to see if there is indeed a function to override
    public void stop() {
        super.stop();
    }

    public void wipeWindShield() {
        System.out.println("Wiping windshield.");
    }

    public void showInfo() {
        System.out.println("Car name: " + name); //not possible b/c name is private in Machine
    }

}

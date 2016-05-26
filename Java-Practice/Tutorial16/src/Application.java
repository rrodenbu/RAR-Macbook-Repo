/**
 * Created by rrodenbu on 5/23/16.
 */
class Robot {
    public void speak() { //method
        System.out.println("Hello");
    }
    public void speakText(String text) { //method
        System.out.println(text);
    }
    public void jump(int height) {
        System.out.println("Jumping: " + height);
    }
    public void move(String direction, double distance) {
        System.out.println("Moving " + distance + " in direction " + direction);
    }
}


public class Application {
    public static void main(String[] args) {
        Robot sam = new Robot();

        sam.speak();
        sam.speakText("Hi, I am Sam."); //calling method with parameter on object
        sam.jump(7);

        sam.move("West", 12.2);

        String greeting = "Hello there.";
        sam.speakText(greeting);

        int jumpDist = 7;
        sam.jump(jumpDist);
    }
}

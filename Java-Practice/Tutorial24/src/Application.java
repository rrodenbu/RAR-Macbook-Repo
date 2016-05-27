/**
 * Created by rrodenbu on 5/26/16.
 * TOPIC: Interfaces
 */
public class Application {

    public static void main(String[] args) {

        Machine mach1 = new Machine();
        mach1.start();

        Person person1 = new Person("Bob");
        person1.greet();

        Info info1 = new Machine(); //Machine implements interface
        info1.showInfo();

        Info info2 = person1;
        info2.showInfo();

        System.out.println();

        outputInfo(mach1);
        outputInfo(person1);
        outputInfo(info2);
    }

    private static void outputInfo(Info info) {
        info.showInfo();
    }

}

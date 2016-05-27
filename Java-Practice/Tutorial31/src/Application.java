import java.lang.reflect.Array;
import java.util.ArrayList;

/**
 * Created by rrodenbu on 5/26/16.
 * TOPIC: Generics and Wildcards
 */
class Machine {

    @Override
    public String toString() {
        return "I am a Machine.";
    }

    public void start() {
        System.out.println("Machine started.");
    }
}

class Camera extends Machine {
    @Override
    public String toString() {
        return "I am a Camera.";
    }

    public void snap() {

        System.out.println("Taken photo.");

    }
}

public class Application {

    public static void main(String[] args) {

        ArrayList<String> list = new ArrayList<>();

        list.add("one");
        list.add("two");

        showList(list);

        ArrayList<Machine> list2 = new ArrayList<>();

        list2.add(new Machine());
        list2.add(new Machine());

        showListMach(list2);

        ArrayList<Machine> list3 = new ArrayList<>();

        list3.add(new Camera());
        list3.add(new Camera());

        showListMach(list3);
        showListAny(list3);

        showListAnyMach(list3);
        showListAnyMach2(list3);

    }

    public static void showList(ArrayList<String> list) {
        for(String value: list) {
            System.out.println(value);
        }
    }

    public static void showListMach(ArrayList<Machine> list) {
        for(Machine value : list) {
            System.out.println(value);
        }
    }

    public static void showListAny(ArrayList<?> list) {
        for(Object value : list) {
            System.out.println(value);
        }
    }

    public static void showListAnyMach(ArrayList<? extends Machine> list) {
        for (Machine value : list) {
            value.start();
            //value.snap(); //Won't work, because it is a Machine not a Camera.
        }
    }

    public static void showListAnyMach2(ArrayList<? super Camera> list) {
        for(Object value : list) { //has to be object
            System.out.println(value);
        }
    }
}

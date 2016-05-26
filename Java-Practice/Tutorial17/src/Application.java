import com.sun.tools.doclets.formats.html.SourceToHTMLConverter;

/**
 * Created by rrodenbu on 5/23/16.
 */

class Frog {
    private String name;
    private int age;

    public void setName(String newName) { //Setter/mutator
        name = newName;
    }

    public void setAge(int age) {
        this.age = age; //this.name = instance variable (class variable);
    } //only time you really need this. When there is ambiguit age vs local age

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    public void setInfo(String name, int age) { //method
        this.setAge(age); //method
        setName(name);
    }

}

public class Application {
    public static void main(String[] args) {
        Frog frog1 = new Frog();

        //frog1.name = "Bob"; //cant do because variables are private
        //frog1.age = 3; //cant do anymore because Frog variables are private

        System.out.println(frog1.getName());
        System.out.println(frog1.getAge());

        frog1.setName("Billy");
        frog1.setAge(5);

        System.out.println(frog1.getName());
        System.out.println(frog1.getAge());

    }
}

import com.sun.scenario.effect.impl.sw.sse.SSEBlend_SRC_OUTPeer;

/**
 * Created by rrodenbu on 5/10/16.
 */
public class Application {
    public static void main(String[] args) {
        int myInt = 5;

        if(myInt < 10) {
            System.out.println("myInt < 10");
        }
        else if (myInt > 10) {
            System.out.println("myInt > 10");
        }
        else {
            System.out.println("myInt == 10");
        }

        int loop = 0;
        while(true) {
            System.out.println("Looping: " + loop);

            if(loop == 5) {
                break;
            }
            loop++;
            System.out.println("Running.");
        }

    }
}

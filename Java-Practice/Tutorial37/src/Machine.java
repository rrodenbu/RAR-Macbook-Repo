/**
 * Created by rrodenbu on 5/27/16.
 */
public abstract class Machine {
    private int id;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    //Requires start() to be implemented individually in each subclass
    //of Machine.
    public abstract void start(); //Kinda like an interface.
    public abstract void doStuff();
    public abstract void shutdown();

    public void run() {
        start();
        doStuff();
        shutdown();
    }

}

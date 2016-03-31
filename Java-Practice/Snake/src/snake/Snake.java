package snake;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;

/**
 * Created by rrodenbu on 3/30/16.
 */
public class Snake implements ActionListener {

    public JFrame jframe;

    public RenderPanel renderPanel;

    public static Snake snake; //allow snake to be accessed anywhere not just in main (where it is declared).

    public Timer timer = new Timer(20, this); //frequency to perform actionPerformed

    public Toolkit toolkit;

    public ArrayList<Point> snakeParts = new ArrayList<Point>();

    public static final int UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3;

    public int ticks = 0, direction = DOWN;

    public Point head;

    public Snake() {
        Dimension dim = Toolkit.getDefaultToolkit().getScreenSize(); //get computers screen size
        jframe = new JFrame("Snake!");                               //create new window with title: Snake!
        jframe.setVisible(true);                                     //make window visible
        jframe.setSize(800,800);                                     //set windows dimnenstions
        jframe.setLocation(dim.width / 2 - jframe.getWidth() / 2, dim.height / 2 - jframe.getHeight() / 2); //center
        jframe.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);       //make it possible to close window
        jframe.add(renderPanel = new RenderPanel());                 //create new panel
        timer.start();
        head = new Point(0,0);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        renderPanel.repaint(); //will repaint window everytime this function is called
        ticks++;
        if (ticks % 10 == 0) { //every half-second (10 ticks)
            if(direction = UP)
                snakeParts.add(new Point(head.x, head.y +));
            snakeParts.add();
        }
    }

    public static void main(String[] args){
        snake = new Snake(); //create new window
    }


}

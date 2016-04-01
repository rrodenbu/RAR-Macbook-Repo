package snake;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Random;

/**
 * Created by rrodenbu on 3/30/16.
 */
public class Snake implements ActionListener {

    //Variables declared up here (outside of Snake function) are public, any function can acess

    public JFrame jframe;

    public RenderPanel renderPanel;

    public static Snake snake; //allow snake to be accessed anywhere not just in main (where it is declared).

    public Timer timer = new Timer(20, this); //frequency to perform actionPerformed

    public Toolkit toolkit;

    public ArrayList<Point> snakeParts = new ArrayList<Point>();

    public static final int UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3, SCALE = 10;
    //SCALE = dimensions of one part of the snake

    public int ticks = 0, direction = DOWN, score, tailLength;

    public Point head, cherry;

    public Random random;

    public boolean over = false; //checks if snake is about to go out of bounds

    public Dimension dim;

    public Snake() {
        dim = Toolkit.getDefaultToolkit().getScreenSize(); //get computers screen size
        jframe = new JFrame("Snake!");                               //create new window with title: Snake!
        jframe.setVisible(true);                                     //make window visible
        jframe.setSize(800,800);                                     //set windows dimnenstions
        jframe.setLocation(dim.width / 2 - jframe.getWidth() / 2, dim.height / 2 - jframe.getHeight() / 2); //center
        jframe.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);       //make it possible to close window
        jframe.add(renderPanel = new RenderPanel());                 //create new panel
        timer.start();
        random = new Random();
        cherry = new Point(dim.width/ SCALE, dim.height / SCALE);
        head = new Point(0,0);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        renderPanel.repaint(); //will repaint window everytime this function is called
        ticks++;

        if (ticks % 10 == 0 && head != null && over != true) { //every half-second (10 ticks)
            snakeParts.add(new Point(head.x, head.y)); //adding new head to array
            //x+ = right y+ = down
            if(direction == UP)
                if (head.y - 1 > 0) //NOT at top of screen
                    head = new Point(head.x, head.y - 1); //change location of head up one point
                else //At top of screen
                    over = true;
            if(direction == DOWN)
                if (head.y + 1 < dim.height / SCALE) //NOT at bottom of screen
                    head = new Point(head.x, head.y + 1); //change location of head down one point
                else //At bottom of screen
                    over = true;
            if(direction == LEFT)
                if (head.x - 1 > 0) //NOT at left edge of screen
                    head = new Point(head.x - 1, head.y); //change location of head left one point
                else //At left edge of screen
                    over = true;
            if(direction == RIGHT)
                if (head.x + 1 < dim.width / SCALE) //NOT at right edge of screen
                    head = (new Point(head.x + 1, head.y)); //change location of head right one point
                else    //At right edge of screen
                    over = true;
            snakeParts.remove(0); //remove the last part of the snake, otherwise it will grow.
            if(cherry != null) {
                if(head.equals(cherry)) {//if(head.x == cherry.x && head.y == cherry.y
                    score += 10; //Add
                    tailLength++;
                    cherry.setLocation(dim.width/SCALE, dim.height / SCALE);
                }
            }
        }
    }

    public static void main(String[] args){
        snake = new Snake(); //create new window
    }


}

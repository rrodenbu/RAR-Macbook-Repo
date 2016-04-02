package snake;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.ArrayList;
import java.util.Random;

import javax.swing.*;
import java.awt.*;

/**
 * Created by rrodenbu on 3/30/16.
 */
public class Snake implements ActionListener, KeyListener {

        //Variables declared up here (outside of Snake function) are public, any function can acess
        //private: anything in this class can see it
        //public: anything in this package can see it
        //public static a: anything anywhere can access it

        public static Snake snake; //allow snake to be accessed anywhere not just in main (where it is declared).

        public JFrame jframe;

        public RenderPanel renderPanel;

        public Timer timer = new Timer(20, this); //frequency to perform actionPerformed

        public ArrayList<Point> snakeParts = new ArrayList<Point>();

        public static final int UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3, SCALE = 20;
        //SCALE = dimensions of one part of the snake

        public int ticks = 0, direction = DOWN, score, tailLength = 0, time;

        public Point head, cherry;

        public Random random;

        public boolean over = false, paused; //checks if snake is about to go out of bounds

        public Dimension dim;

        public Snake()
        {
                dim = Toolkit.getDefaultToolkit().getScreenSize(); //get computers screen size
                jframe = new JFrame("Snake!"); //create new window with title: Snake!
                jframe.setVisible(true); //make window visible
                jframe.setSize(400 , 400); //set windows dimensions
                jframe.setResizable(false); //prevents cheat where you could resize the screen
                jframe.setLocation(dim.width / 2 - jframe.getWidth() / 2, dim.height / 2 - jframe.getHeight() / 2); //center
                jframe.add(renderPanel = new RenderPanel());//create new panel
                jframe.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);       //make it possible to close window
                jframe.addKeyListener(this);
                startGame();
        }

        //resets to original game state: snake top left corner going down
        //  score = 0, time = 0, new cherry, etc.
        public void startGame ()
        {
                over = false;
                paused = false;
                score = 0;
                time = 0;
                tailLength = 5;
                ticks = 0;
                direction = DOWN;
                head = new Point(0, -1);
                snakeParts.clear();
                random = new Random();
                cherry = new Point(random.nextInt(391), random.nextInt(368));
                timer.start();
        }

        @Override
        public void actionPerformed(ActionEvent e)
        {
                renderPanel.repaint(); //will repaint window everytime this function is called
                ticks ++;
                int snakeSpeed = 1;

                if (ticks % snakeSpeed == 0 && head != null && over != true && !paused)
                { //every half-second (10 ticks)
                        snakeParts.add(new Point(head.x, head.y));
                        //x+ = right y+ = down
                        if(direction == UP)
                            if (head.y - 1 >= 0 && noTailAt(head.x, head.y -1)) //NOT at top of screen
                                head = new Point(head.x, head.y - 1); //change location of head up one point
                            else //At top of screen
                                over = true;

                        if(direction == DOWN)
                            if (head.y + 1 < 368 && noTailAt(head.x, head.y + 1)) //NOT at bottom of screen
                                head = new Point(head.x, head.y + 1); //change location of head down one point
                            else //At bottom of screen
                                over = true;

                        if(direction == LEFT)
                            if (head.x - 1 >= 0 && noTailAt(head.x - 1, head.y)) //NOT at left edge of screen
                                head = new Point(head.x - 1, head.y); //change location of head left one point
                            else //At left edge of screen
                                over = true;

                        if(direction == RIGHT)
                            if (head.x + 1 < 391 && noTailAt(head.x + 1, head.y)) //NOT at right edge of screen
                                head = new Point(head.x + 1, head.y); //change location of head right one point
                            else    //At right edge of screen
                                over = true;

                        //snakeParts.add(new Point(head.x, head.y)); //adding new head to array

                        if(snakeParts.size() > tailLength) //Head moved need to remove tail.
                            snakeParts.remove(0);

                        if(cherry != null) {
                            if(head.equals(cherry)) {//if(head.x == cherry.x && head.y == cherry.y
                                score += 10; //i.e. add to length of snake
                                tailLength++;
                                cherry.setLocation(random.nextInt(391), random.nextInt(368));
                            }
                        }
                }
        }

        public boolean noTailAt(int x, int y)
        {
            for(Point point : snakeParts) //loop through all snake parts
            {
                if (point.equals(new Point(x, y)))
                {
                    return false;
                }
            }
            return true;
        }

        public static void main(String[] args)
        {
            snake = new Snake(); //create new window
        }


        @Override
        public void keyTyped(KeyEvent e) {
        }

        @Override
        public void keyPressed(KeyEvent e) { //keyboard button pressed (passed in as e)
            int i = e.getKeyCode(); //retrieving the key that was pressed
            if (i == KeyEvent.VK_LEFT && direction != RIGHT) //'A' key is left and checking to make your turning back on self
                direction = LEFT;
            if (i == KeyEvent.VK_RIGHT && direction != LEFT) // 'D' key is right
                direction = RIGHT;
            if (i == KeyEvent.VK_UP && direction != DOWN) // 'W' key is up
                direction = UP;
            if (i == KeyEvent.VK_DOWN && direction != UP) // 'S' key is down
                direction = DOWN;
            if (i == KeyEvent.VK_SPACE) //GAME OVER: hit edge of screen
                if (over)
                    startGame(); //press space to restart
            else
                    paused = !paused;
        }

        @Override
        public void keyReleased(KeyEvent e) {
        }
}

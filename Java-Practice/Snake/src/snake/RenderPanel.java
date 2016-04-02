package snake;

import javax.swing.JPanel;
import java.awt.*;

/**
 * Created by rrodenbu on 3/30/16.
 * Creates the actual game, in a new screen.
 */
@SuppressWarnings("serial")
public class RenderPanel extends JPanel
{
        public static final Color GREEN = new Color(13434675); //set games background color
        public static final Color DULLGREY = new Color(196196255);

        @Override
        protected void paintComponent(Graphics g)
        {
                super.paintComponent(g);

                //set background color
                g.setColor(GREEN);     //also: new Color(0)
                g.fillRect(0, 0, 400, 400);  //set size of fill

                //set snake head and parts color
                g.setColor(Color.BLACK);
                Snake snake = Snake.snake;
                for (Point point: snake.snakeParts){ //loop through all the parts in snakes body (array of parts)
                    System.out.println("(" + point.x + "," + point.y + ")");
                    System.out.println("   (" + point.x*snake.SCALE + "," + point.y*snake.SCALE + ")");
                    g.fillRect((point.x, point.y, snake.SCALE, snake.SCALE);
                }
                g.fillRect(snake.head.x, snake.head.y, Snake.SCALE, Snake.SCALE);

                //set snakes food color
                g.setColor(Color.RED);
                g.fillRect(snake.cherry.x, snake.cherry.y, snake.SCALE, snake.SCALE);

                //Sets text and text color
                g.setColor(DULLGREY);
                String string = "Score: " + snake.score + ", Length: " + snake.tailLength + "Time: " + snake.time / 20;
                g.drawString(string, (int) (getWidth() / 2 - string.length() * 2.5f), 10);

                string = "Game Over!";
                if (snake.over)
                {
                    g.drawString(string, (int) (getWidth() / 2 - string.length() * 2.5f), (int) snake.dim.getHeight() / 4);
                }

                string = "Paused!";
                if (snake.paused && !snake.over)
                {
                    g.drawString(string, (int) (getWidth() / 2 - string.length() * 2.5f), (int) snake.dim.getHeight() / 4);
                }
        }
}

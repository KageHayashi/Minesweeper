import de.bezier.guido.*;

public final static int NUM_ROWS = 50;
public final static int NUM_COLS = 50;
public final static int NUM_BOMBS = 500;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup () {
  size(800, 800);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      buttons[r][c] = new MSButton(r,c);
    }
  }
  setBombs();
}
public void setBombs() {
  while(bombs.size() < NUM_BOMBS) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if(!bombs.contains(buttons[r][c])) {
      bombs.add(buttons[r][c]);
    }
  }
}

public void draw () {
  background( 0 );
  if (isWon())
    displayWinningMessage();
}
public boolean isWon() {
  for (int r1 = 0; r1 < NUM_ROWS; r1++) {
    for (int c1 = 0; c1 < NUM_COLS; c1++) {
      if (buttons[r1][c1].isClicked()) {
        return true;
      }
    }
  }
  return false;
}
public void displayLosingMessage() {
  
}
public void displayWinningMessage() {
  
}

public class MSButton {
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc ) {
    width = 800/NUM_COLS;
    height = 800/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked() {
    return marked;
  }
  public boolean isClicked() {
    return clicked;
  }
  // called by manager

  public void mousePressed () {
    clicked = true;
    if (mouseButton == RIGHT) {
      marked = !marked;
      if (marked == false) {
        clicked = false;
      }
    }
    else if (bombs.contains(this)) {
      displayLosingMessage();
    }
    else if (countBombs(r,c) > 0) {
      setLabel("" + countBombs(r,c));
    }
    else {
      for (int r1 = r - 1; r1 < r + 2; r1 ++) {
        for (int c1 = c - 1; c1 < c + 2; c1++) {
          if (isValid(r1,c1) && buttons[r1][c1].isClicked() == false) {
            buttons[r1][c1].mousePressed();
        }
      }
     }
   }
}

  public void draw () {    
    if (marked)
      fill(0);
    else if( clicked && bombs.contains(this) ) 
      fill(255,0,0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel){
    label = newLabel;
  }
  public boolean isValid(int r, int c){
    if (r >= 0 && r < NUM_ROWS) {
      if (c >= 0 && c < NUM_COLS) {
        return true;
      }
      return false;
    }
    return false;
  }
  
  public int countBombs(int row, int col){
    int numBombs = 0;
    for (int r = row - 1; r < row + 2; r ++) {
      for (int c = col - 1; c < col + 2; c++) {
        if (isValid(r,c) &&  bombs.contains(buttons[r][c])== true) {
          numBombs++;
      }
    }
  }
  if (bombs.contains(buttons[row][col]) == true) {
    numBombs--;
  }
    return numBombs;
  }
}

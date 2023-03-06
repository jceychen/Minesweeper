import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make(this);

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < buttons.length; r++) {
    for (int c = 0; c < buttons[r].length; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  setMines();
}

public void setMines()
{
  while (mines.size() < 50)
  {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);        
    if (!mines.contains(buttons[row][col]))
      mines.add(buttons[row][col]);
    else
      setMines();
  }
}

public void draw()
{
  background(0);
  if (isWon()) {
    displayWinningMessage();
  }
}

public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!buttons[r][c].clicked == true && !mines.contains(buttons[r][c])) {
        return false;
      }
    }
  }
  return true;
}

public void displayLosingMessage()
{
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      if (!buttons[r][c].clicked == true && mines.contains(buttons[r][c])) {
        buttons[r][c].flagged = false;
        buttons[r][c].clicked = true;
        buttons[9][6].setLabel("n");
        buttons[9][7].setLabel("i");
        buttons[9][8].setLabel("c");
        buttons[9][9].setLabel("e");
        buttons[9][11].setLabel("t");
        buttons[9][12].setLabel("r");
        buttons[9][13].setLabel("y");
      }
    }
  }
}

public void displayWinningMessage()
{
  buttons[9][6].setLabel("w");
  buttons[9][7].setLabel("i");
  buttons[9][8].setLabel("n");
  buttons[9][9].setLabel("n");
  buttons[9][10].setLabel("e");
  buttons[9][11].setLabel("r");
  buttons[9][12].setLabel("!");
}

public boolean isValid(int r, int c)
{
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
    return true;
  return false;
}

public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i = row-1; i < row+2; i++) {
    for (int j = col-1; j < col+2; j++) {
      if (isValid(i, j) && mines.contains(buttons[i][j])) {
        numMines++;
      }
    }
  }  
  return numMines;
}

public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton (int row, int col)
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol * width;
    y = myRow * height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add(this); // register it with the manager
  }

  public void mousePressed() 
  {
    clicked = true;
    if (keyPressed == true) {
      flagged =! flagged;
      clicked = false;
    } else if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(str(countMines(myRow, myCol)));
    } else {
      for (int row = myRow-1; row < myRow+2; row++) {
        for (int col = myCol-1; col < myCol+2; col++) {
          if (isValid(row, col) && !buttons[row][col].clicked == true) {
            buttons[row][col].mousePressed();
          }
        }
      }
    }
  }

  public void draw () 
  {    
    stroke(255);
    if (flagged)
      fill(250, 128, 114);
    else if (clicked && mines.contains(this)) 
      fill(0);
    else if (clicked)
      fill(227, 115, 131);
    else 
      fill(255, 182, 193);

    rect(x, y, width, height);
    fill(255);
    text(myLabel, x+width/2, y+height/2);
  }

  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }

  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }

  public boolean isFlagged()
  {
    return flagged;
  }
}

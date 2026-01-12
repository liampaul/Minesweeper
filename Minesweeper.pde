int rownum = 32;
boolean[][] minefield;
boolean[][] cover = new boolean[rownum][rownum];
boolean[][] flags = new boolean[rownum][rownum];
void setup()
{
    minefield = GenerateMinefield();
    cover = fill2D(cover, true);
    flags = fill2D(flags,false);
    size(800,800);
}
void draw()
{
    for(int i = 0; i<minefield.length;i++)
    {
        for(int j = 0; j<minefield[i].length;j++)
        {
           fill(150);
           if(cover[i][j])fill(100);
           if(cover[i][j]&&flags[i][j]) fill(150,100,100);
           rect(i*800/rownum, j*800/rownum, 800/rownum, 800/rownum);
           fill(0);
           textSize(15);
           if(!minefield[i][j]&&!cover[i][j])text(Integer.toString(countNeighborTrues(i,j)), i*800/rownum+800/rownum/2, j*800/rownum+800/rownum/2);
        }
  }
}
public boolean[][] GenerateMinefield()
{
    boolean[][] field = new boolean[rownum][rownum];

    for(int i = 0; i<field.length;i++)
    {
        for(int j = 0; j<field[i].length;j++)
        {
            if(Math.random()>.13)field[i][j]=false; else field[i][j]=true;
        }
  }
  return field;
}
public int countNeighborTrues(int row, int col){
  int[][] adj = {{1,0},{-1,0},{0,1},{0,-1},{1,1},{-1,-1},{1,-1},{-1,1}};
  int count =0;
  for(int[] n:adj)
  {
    if(isValidOnNbyN(rownum, rownum, row+n[1], col+n[0]) && minefield[row+n[1]][col+n[0]])count++;
  }
  return count;
}
public boolean isValidOnNbyN(int NUM_ROWS, int NUM_COLS, int row, int col){
    return (row>=0 && row<NUM_ROWS)&&(col>=0 && col<NUM_COLS);
}
public boolean[][] fill2D(boolean[][] vals, boolean val){
  for(int i = 0; i<vals.length;i++)
  {
    for(int j = 0; j<vals[i].length;j++)
    {
      vals[i][j]=val;
    }
  }
  return vals;
}
void clear(int row, int col, int it)
{
    if(it==0)
    {
        cover[row][col] = false;
    }
    if(it<5 && countNeighborTrues(row, col)==0)
    {
    int[][] adj = {{1,0},{-1,0},{0,1},{0,-1},{1,1},{-1,-1},{1,-1},{-1,1}};
    for(int[] n:adj)
    {
        int newRow = row+n[1];
        int newCol = col+n[0];
        if(isValidOnNbyN(rownum, rownum, newRow, newCol))
        {
            cover[newRow][newCol] = false;
            clear(newRow, newCol, it +1);
        }
    }
    }

}
void mousePressed()
{
    int i=(int)(mouseY/(800/rownum));
    int j=(int)(mouseX/(800/rownum));
    if(mouseButton==LEFT)
    {
        if(minefield[j][i])
        {
            cover = fill2D(cover, true);
            flags = fill2D(flags,false);
            minefield = GenerateMinefield();
        }
        else clear(j,i,0);
    }
    else
    {
        flags[j][i]=!flags[j][i];
    }
}

/*

 Author: Yannis STEFANELLI

 Creation Date: 09-01-2023 21:48:43

 Description : basic class for defining a piece composed of multiple blocks

*/

#include <SFML/Graphics.hpp>
#include "./board.h"
using namespace sf;

class Tetromino {
    private :
        int size{}; //used to scale down/up pieces
        char type{}; //this is the style of the piece
        IntRect bounds; //texture bounds (24px)
        Vector2i boardSize; //board size
        
    public :
        Tetromino(Texture *texture, Vector2i boardSize); //constructor
        Vector2i pos;
        Sprite blocks[4]; //sprite board containing each block inside a piece
        int state{}; //rotation state (max 4) = 360 degrees
        void display(Board board);
        void setpos(Vector2i pos, int state);
        void reset();
        void resetType();
        char getType();
        bool canControl = true;
        int style = 0;
        //void setStyle(int style);

	static bool verifyColision(const Tetromino &piece, const std::vector <Sprite> &blockList, Board &board, char direction);
};
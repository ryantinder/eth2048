pragma solidity ^0.8.0;
contract eth2048 {
  event gameUpdate(uint game);
  function state() public returns (uint) {
    uint game = 0;

    game = (~game << (6 * 7)); //fill top row
    game = ~(~(game << 7) << (4 * 7)) << 7; //fill game row
    game = ~(~(game << 7) << (4 * 7)) << 7; //fill game row
    game = ~(~(game << 7) << (4 * 7)) << 7; //fill game row
    game = ~(~(game << 7) << (4 * 7)) << 7; //fill game row
    game = ~(game << (6 * 7));
    game = setSquare(game, 4, 3, 27);
    game = setSquare(game, 2, 3, 28);
    game = setSquare(game, 2, 4, 29);
    game = setSquare(game, 1, 4, 30);
    return move(game, 3);
  }

  function move(uint game, uint dir) public returns (uint) {
    if (dir == 1) { //Move down
      for (uint row = 0; row < 6; row++) {
        for (uint pos = 0; pos < 6; pos++) {
          uint active = checkSquare(game, row, pos);
          if (active == 127 || active == 0) {
            continue;
          } 
          uint nextSquare = checkSquare(game, row - 1, pos);
          if (nextSquare == 127) {
            continue;
          }

          //Move
          uint next_row = row - 1;
          while (checkSquare(game, next_row, pos) == 0) {
            game = setSquare(game, next_row, pos, active);
            game = clearSquare(game, next_row + 1, pos);
            next_row--;
          }

          //Check
          nextSquare = checkSquare(game, next_row, pos);
          if (active == nextSquare) {
            game = setSquare(game, next_row, pos, nextSquare + 1);
            game = clearSquare(game, next_row + 1, pos);
            if (checkSquare(game, next_row, pos) == 11) { //Winner detected, will use events eventually.
                return game;
            }
            next_row--;

          } else {
            continue;
          }
          //Move again
          next_row = next_row - 1;
          while (checkSquare(game, next_row, pos) == 0) {
            game = setSquare(game, next_row, pos, active);
            game = clearSquare(game, next_row + 1, pos);
            next_row--;
          }
        }
      }
    }
    else if (dir == 3) { //Move up
      for (uint row = 4; row > 0; row--) {
        for (uint pos = 1; pos < 5; pos++) {
          uint active = checkSquare(game, row, pos);
          if (active == 127 || active == 0) {
            continue;
          }

          uint nextSquare = checkSquare(game, row + 1, pos);
          if (nextSquare == 127) {
            continue;
          }

          //Move
          uint next_row = row + 1;
          while (checkSquare(game, next_row, pos) == 0) {
            game = setSquare(game, next_row, pos, active);
            game = clearSquare(game, next_row - 1, pos);
            next_row++;
          }

          //Check
          nextSquare = checkSquare(game, next_row, pos);
          if (active == nextSquare) {
            game = setSquare(game, next_row, pos, nextSquare + 1);
            game = clearSquare(game, next_row - 1, pos);
            next_row++;
          } else { //we've hit a piece
            continue;
          }

          //Move again
          next_row = next_row + 1;
          while (checkSquare(game, next_row, pos) == 0) {
            game = setSquare(game, next_row, pos, active);
            game = clearSquare(game, next_row - 1, pos);
            next_row++;
          }
        }
      }
    } 
    else if (dir == 2) { //Move left
      for (uint pos = 4; pos > 0; pos--) {
        for (uint row = 1; row < 5; row++) {
          uint active = checkSquare(game, row, pos);
          if (active == 127 || active == 0) {
            continue;
          }

          uint nextSquare = checkSquare(game, row, pos + 1);
          if (nextSquare == 127) {
            continue;
          }

          //Move
          uint next_pos = pos + 1;
          while (checkSquare(game, row, next_pos) == 0) {
            game = setSquare(game, row, next_pos, active);
            game = clearSquare(game, row, next_pos - 1);
            next_pos++;
          }

          //Check
          nextSquare = checkSquare(game, row, next_pos);
          if (active == nextSquare) {
            game = setSquare(game, row, next_pos, nextSquare + 1);
            game = clearSquare(game, row, next_pos - 1);
            next_pos++;
          } else { //we've hit a piece
            continue;
          }

          //Move again
          next_pos = next_pos + 1;
          while (checkSquare(game, row, next_pos) == 0) {
            game = setSquare(game, row, next_pos, active);
            game = clearSquare(game, row, next_pos - 1);
            next_pos++;
          }
        }
      }
    } else if (dir == 4) { //Move right
      for (uint pos = 1; pos < 5; pos++) {
        for (uint row = 1; row < 5; row++) {
          uint active = checkSquare(game, row, pos);
          if (active == 127 || active == 0) {
            continue;
          }

          uint nextSquare = checkSquare(game, row, pos - 1);
          if (nextSquare == 127) {
            continue;
          }

          //Move
          uint next_pos = pos - 1;
          while (checkSquare(game, row, next_pos) == 0) {
            game = setSquare(game, row, next_pos, active);
            game = clearSquare(game, row, next_pos + 1);
            next_pos--;
          }

          //Check
          nextSquare = checkSquare(game, row, next_pos);
          if (active == nextSquare) {
            game = setSquare(game, row, next_pos, nextSquare + 1);
            game = clearSquare(game, row, next_pos + 1);
            next_pos--;
          } else { //we've hit a piece
            continue;
          }

          //Move again
          next_pos = next_pos - 1;
          while (checkSquare(game, row, next_pos) == 0) {
            game = setSquare(game, row, next_pos, active);
            game = clearSquare(game, row, next_pos + 1);
            next_pos--;
          }
        }
      }
    }
    //Create random new Square
    game = newSquare(game, dir);
    emit gameUpdate(game);
    return game;
  }


  function newSquare(uint game, uint dir) public returns (uint) {
    if (dir == 1) { //Create new square on top row
      return setSquare(game, 4, ((block.timestamp * block.number) % 4) + 1, ((block.timestamp * block.number) % 3) + 1);
    } else if (dir == 3) { //move up
      return setSquare(game, 1, ((block.timestamp * block.number) % 4) + 1, ((block.timestamp * block.number) % 3) + 1);
    } else if (dir == 2) { //move left
      return setSquare(game, ((block.timestamp * block.number) % 4) + 1, 1, ((block.timestamp * block.number) % 3) + 1);
    } else {
      return setSquare(game, ((block.timestamp * block.number) % 4) + 1, 4, ((block.timestamp * block.number) % 3) + 1);
    }
  }
  function checkSquare(uint game, uint row, uint pos) public returns(uint) {
    return (game >> (row * 6 * 7) + pos * 7) & ~(~(0) << 7);
  }
  function clearSquare(uint game, uint row, uint pos) public returns(uint) {
    return ~(~(~uint(0) << 7) << row * 6 * 7 + (pos * 7)) & game;
  }
  function setSquare(uint game, uint row, uint pos, uint val) public returns(uint) {
    game = clearSquare(game, row, pos);
    return (val << (row * 6 * 7) + pos * 7) | game;
  }
}
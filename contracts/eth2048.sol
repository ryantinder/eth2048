pragma solidity ^0.8.0;
contract eth2048 {
  event gameUpdate(address indexed addr, uint game);
  mapping(address => uint) games;
  function createGame() public {
    games[msg.sender] = _createGame();
    emit gameUpdate(msg.sender, games[msg.sender]);
  }
  function _createGame() private view returns (uint) {
    uint game = 0;
    game = (~game << (6 * 7)); //fill top row
    game = ~(~(game << 7) << (4 * 7)) << 7; //fill game row
    game = ~(~(game << 7) << (4 * 7)) << 7; //fill game row
    game = ~(~(game << 7) << (4 * 7)) << 7; //fill game row
    game = ~(~(game << 7) << (4 * 7)) << 7; //fill game row
    game = ~(game << (6 * 7));
    //This will need to be random
    uint seed = (block.timestamp * block.gaslimit * block.number) % 10e9;
    game = _setSquare(game, (seed % 4) + 1, (seed % 3) + 2, 1);
    seed = (seed * block.timestamp * block.gaslimit * block.number) % 10e9;
    game = _setSquare(game, (seed % 3) + 2, (seed % 4) + 1, 1);
    seed = (seed * block.timestamp * block.gaslimit * block.number) % 10e9;
    game = _setSquare(game, (seed % 4) + 1, (seed % 3) + 2, 1);
    seed = (seed * block.timestamp * block.gaslimit * block.number) % 10e9;
    game = _setSquare(game, (seed % 3) + 2, (seed % 4) + 1, 1);
    return game;
  }
  function move(uint dir) public {
    if (dir < 1 || dir > 4) revert("Invalid direction");
    games[msg.sender] = _move(games[msg.sender], dir);
    emit gameUpdate(msg.sender, games[msg.sender]);
  }
  // 1 = down, 2 = left, 3 = up, 4 = right
  function _move(uint game, uint dir) private view returns (uint) {
    if (dir == 1) { //Move down
      for (uint row = 0; row < 6; row++) {
        for (uint pos = 0; pos < 6; pos++) {
          uint active = _checkSquare(game, row, pos);
          if (active == 127 || active == 0) {
            continue;
          }
          uint nextSquare = _checkSquare(game, row - 1, pos);
          if (nextSquare == 127) {
            continue;
          }


          //Move
          uint next_row = row - 1;
          while (_checkSquare(game, next_row, pos) == 0) {
            game = _setSquare(game, next_row, pos, active);
            game = _clearSquare(game, next_row + 1, pos);
            next_row--;
          }

          //Check
          nextSquare = _checkSquare(game, next_row, pos);
          if (active == nextSquare) {
            game = _setSquare(game, next_row, pos, nextSquare + 1);
            game = _clearSquare(game, next_row + 1, pos);
            next_row--;

          } else {
            continue;
          }

          //Move again
          if (next_row == 0) {
            continue;
          }
          next_row = next_row - 1;
          while (_checkSquare(game, next_row, pos) == 0 && next_row > 0) {
            game = _setSquare(game, next_row, pos, active);
            game = _clearSquare(game, next_row + 1, pos);
            next_row--;
          }
        }
      }
    }
    else if (dir == 3) { //Move up
      for (uint row = 4; row > 0; row--) {
        for (uint pos = 1; pos < 5; pos++) {
          uint active = _checkSquare(game, row, pos);
          if (active == 127 || active == 0) {
            continue;
          }

          uint nextSquare = _checkSquare(game, row + 1, pos);
          if (nextSquare == 127) {
            continue;
          }

          //Move
          uint next_row = row + 1;
          while (_checkSquare(game, next_row, pos) == 0) {
            game = _setSquare(game, next_row, pos, active);
            game = _clearSquare(game, next_row - 1, pos);
            next_row++;
          }

          //Check
          nextSquare = _checkSquare(game, next_row, pos);
          if (active == nextSquare) {
            game = _setSquare(game, next_row, pos, nextSquare + 1);
            game = _clearSquare(game, next_row - 1, pos);
            next_row++;
          } else { //we've hit a piece
            continue;
          }
          //Move again
          next_row = next_row + 1;
          while (_checkSquare(game, next_row, pos) == 0 && next_row < 5) {
            game = _setSquare(game, next_row, pos, active);
            game = _clearSquare(game, next_row - 1, pos);
            next_row++;
          }
        }
      }
    } 
    else if (dir == 2) { //Move left
      for (uint pos = 4; pos > 0; pos--) {
        for (uint row = 1; row < 5; row++) {
          uint active = _checkSquare(game, row, pos);
          if (active == 127 || active == 0) {
            continue;
          }

          uint nextSquare = _checkSquare(game, row, pos + 1);
          if (nextSquare == 127) {
            continue;
          }

          //Move
          uint next_pos = pos + 1;
          while (_checkSquare(game, row, next_pos) == 0) {
            game = _setSquare(game, row, next_pos, active);
            game = _clearSquare(game, row, next_pos - 1);
            next_pos++;
          }

          //Check
          nextSquare = _checkSquare(game, row, next_pos);
          if (active == nextSquare) {
            game = _setSquare(game, row, next_pos, nextSquare + 1);
            game = _clearSquare(game, row, next_pos - 1);
            next_pos++;
          } else { //we've hit a piece
            continue;
          }

          //Move again
          next_pos = next_pos + 1;
          while (_checkSquare(game, row, next_pos) == 0 && next_pos < 5) {
            game = _setSquare(game, row, next_pos, active);
            game = _clearSquare(game, row, next_pos - 1);
            next_pos++;
          }
        }
      }
    } else if (dir == 4) { //Move right
      for (uint pos = 1; pos < 5; pos++) {
        for (uint row = 1; row < 5; row++) {
          uint active = _checkSquare(game, row, pos);
          if (active == 127 || active == 0) {
            continue;
          }

          uint nextSquare = _checkSquare(game, row, pos - 1);
          if (nextSquare == 127) {
            continue;
          }

          //Move
          uint next_pos = pos - 1;
          while (_checkSquare(game, row, next_pos) == 0) {
            game = _setSquare(game, row, next_pos, active);
            game = _clearSquare(game, row, next_pos + 1);
            next_pos--;
          }

          //Check
          nextSquare = _checkSquare(game, row, next_pos);
          if (active == nextSquare) {
            game = _setSquare(game, row, next_pos, nextSquare + 1);
            game = _clearSquare(game, row, next_pos + 1);
            next_pos--;
          } else { //we've hit a piece
            continue;
          }

          //Move again
          if (next_pos == 0) {
            continue;
          }
          next_pos = next_pos - 1;
          while (_checkSquare(game, row, next_pos) == 0 && next_pos > 0) {
            game = _setSquare(game, row, next_pos, active);
            game = _clearSquare(game, row, next_pos + 1);
            next_pos--;
          }
        }
      }
    }
    //Create random new Square
    game = newSquare(game, dir);
    return game;
  }


  function newSquare(uint game, uint dir) public view returns (uint) {
    if (dir == 1) { //Create new square on top row
      return _setSquare(game, 4, ((block.timestamp * block.number) % 4) + 1, ((block.timestamp * block.number) % 3) + 1);
    } else if (dir == 3) { //move up
      return _setSquare(game, 1, ((block.timestamp * block.number) % 4) + 1, ((block.timestamp * block.number) % 3) + 1);
    } else if (dir == 2) { //move left
      return _setSquare(game, ((block.timestamp * block.number) % 4) + 1, 1, ((block.timestamp * block.number) % 3) + 1);
    } else {
      return _setSquare(game, ((block.timestamp * block.number) % 4) + 1, 4, ((block.timestamp * block.number) % 3) + 1);
    }
  }
  function _checkSquare(uint game, uint row, uint pos) private pure returns(uint) {
    return (game >> (row * 6 * 7) + pos * 7) & ~(~(0) << 7);
  }
  function _clearSquare(uint game, uint row, uint pos) private pure returns(uint) {
    return ~(~(~uint(0) << 7) << row * 6 * 7 + (pos * 7)) & game;
  }
  function _setSquare(uint game, uint row, uint pos, uint val) private pure returns(uint) {
    game = _clearSquare(game, row, pos);
    return (val << (row * 6 * 7) + pos * 7) | game;
  }
}
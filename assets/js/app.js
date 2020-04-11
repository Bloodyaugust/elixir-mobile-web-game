// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import socket from "./socket"

(() => {
  const createGameButton = document.getElementById('create-game');
  const gameList = document.getElementById('game-list');
  const startGameButtons = document.querySelectorAll('input.start-game[type="button"]');

  const allGameChannel = socket.channel('game:all', {});

  allGameChannel.on('creating', payload => {
    console.log(payload);
  });

  allGameChannel.on('created', payload => {
    let listItem = document.createElement('li');
    listItem.innerText = payload.body;
    gameList.appendChild(listItem);
  });

  allGameChannel.join()
    .receive('ok', resp => { console.log('Joined successfully', resp) })
    .receive('error', resp => { console.log('Unable to join', resp) });

  createGameButton.addEventListener('click', () => {
    allGameChannel.push('create', { body: 'do it' });
  });

  startGameButtons.forEach(button => {
    button.addEventListener('click', event => {
      const startGameChannel = socket.channel(`game:${event.target.dataset.id}`, {});

      startGameChannel.on('started', payload => {
        console.log('started', payload);
      });

      startGameChannel.join()
        .receive('ok', resp => {
          console.log('Joined successfully', resp);
          startGameChannel.push(`start:${event.target.dataset.id}`, { body: 'do it' });
        })
        .receive('error', resp => { console.log('Unable to join', resp) });
    });
  });
})();
